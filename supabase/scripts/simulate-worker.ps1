# B7c worker simulation (no WhatsApp worker yet).
# Creates the pairing row for one account, then calls ingest_ai_proposal exactly
# like the future n8n flow will. Service role key stays in the environment only.
#
#   $env:SUPABASE_URL = '<project url from .env.local>'
#   $env:SUPABASE_SERVICE_ROLE_KEY = '<dashboard -> settings -> API -> secret key>'
#   ./supabase/scripts/simulate-worker.ps1 -OwnerEmail 'naufalfaiz6381@gmail.com'
#
param(
  [Parameter(Mandatory = $true)][string]$OwnerEmail,
  [string]$SourceText = 'Cuci 3 kg, antar sore ya',
  [string]$CustomerName = 'Pelanggan Uji',
  [string]$Phone = '081234567890',
  [string]$Address = 'Jl. Uji 1',
  [string]$ServiceHint = '',
  [switch]$Raw
)
$ErrorActionPreference = 'Stop'
$url = $env:SUPABASE_URL
$key = $env:SUPABASE_SERVICE_ROLE_KEY
if ([string]::IsNullOrWhiteSpace($url) -or [string]::IsNullOrWhiteSpace($key)) {
  throw 'Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY first.'
}
$headers = @{ apikey = $key; Authorization = "Bearer $key"; 'Content-Type' = 'application/json' }
$agent = 'laurum-worker/1.0'
$now = [DateTime]::UtcNow
$iso = { param($t) $t.ToString('yyyy-MM-ddTHH:mm:ss.ffffffZ') }

# 1. Resolve the owner from the email (server decides identity, never the payload).
$users = Invoke-RestMethod -Uri "$url/auth/v1/admin/users?page=1&per_page=200" -Headers $headers -UserAgent $agent
$owner = $users.users | Where-Object { $_.email -eq $OwnerEmail } | Select-Object -First 1
if ($null -eq $owner) { throw "No auth user with email $OwnerEmail" }
$ownerId = $owner.id

# 2. One connection per account; an existing instance id must never change.
$existing = Invoke-RestMethod -Uri "$url/rest/v1/wa_connections?owner_id=eq.$ownerId&select=id,instance_id" -Headers $headers -UserAgent $agent
$connectionId = if ($existing.Count -gt 0) { $existing[0].id } else { [guid]::NewGuid().ToString() }
$instanceId = if ($existing.Count -gt 0) { $existing[0].instance_id } else { "laurum-sim-$($ownerId.Substring(0,8))" }
$connection = @{
  id           = $connectionId
  owner_id     = $ownerId
  instance_id  = $instanceId
  status       = 'terhubung'
  connected_at = & $iso $now.AddMinutes(-1)
}
$connectionHeaders = $headers.Clone()
$connectionHeaders['Prefer'] = 'resolution=merge-duplicates'
Invoke-RestMethod -Method Post -Uri "$url/rest/v1/wa_connections?on_conflict=owner_id" `
  -Headers $connectionHeaders -UserAgent $agent -Body (ConvertTo-Json $connection -Depth 4) | Out-Null

# 3. Worker ingress: ordinary fields from the webhook, content from the LLM JSON.
$payload = @{
  source_text       = $SourceText
  customer_name     = $CustomerName
  phone             = $Phone
  address           = $Address
  uncertain_address = $false
  cancel_requested  = $false
  confidence        = 0.9
}
if ($ServiceHint -ne '') { $payload.service_hint = $ServiceHint }
$body = @{
  p_instance_id   = $instanceId
  p_wa_message_id = "sim-$([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())"
  p_chat_id       = '62812@c.us'
  p_received_at   = & $iso $now
  p_payload       = $payload
}
$result = Invoke-RestMethod -Method Post -Uri "$url/rest/v1/rpc/ingest_ai_proposal" `
  -Headers $headers -UserAgent $agent -Body (ConvertTo-Json $body -Depth 5)
if ($Raw) { $result | ConvertTo-Json -Depth 5 } else {
  Write-Output "owner=$ownerId instance=$instanceId code=$($result.code) proposal=$($result.proposal_id)"
}
if ($result.code -ne 'created') { exit 1 }
