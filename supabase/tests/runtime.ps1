# Run from repository root with the local stack and functions serve already active.
# Never echo the CLI status payload: it includes local credentials.
$runtimePreviousErrorPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'
$runtimePublicBefore = $env:LAURUM_LOCAL_PUBLIC_KEY
$runtimeServiceBefore = $env:LAURUM_LOCAL_SERVICE_KEY
try {
  $ErrorActionPreference = 'Continue'
  $runtimeRaw = & ./supabase/node_modules/.bin/supabase.cmd status --workdir . --output json 2>$null
  $runtimeStatusExit = $LASTEXITCODE
  $ErrorActionPreference = 'Stop'
  if ($runtimeStatusExit -ne 0) { throw 'Local Supabase status unavailable' }
  try { $runtimeStatus = ($runtimeRaw -join "`n") | ConvertFrom-Json }
  catch { throw 'Local Supabase status format unavailable' }
  if ($runtimeStatus.API_URL -ne 'http://127.0.0.1:54321') { throw 'Only the local API is allowed' }
  $env:LAURUM_LOCAL_PUBLIC_KEY = $runtimeStatus.ANON_KEY
  $env:LAURUM_LOCAL_SERVICE_KEY = $runtimeStatus.SERVICE_ROLE_KEY
  if (-not $env:LAURUM_LOCAL_PUBLIC_KEY -or -not $env:LAURUM_LOCAL_SERVICE_KEY) {
    throw 'Local test keys unavailable'
  }
  node --test supabase/tests/runtime.test.mjs
  $runtimeExit = $LASTEXITCODE
} finally {
  $runtimeRaw = $null
  $runtimeStatus = $null
  $env:LAURUM_LOCAL_PUBLIC_KEY = $runtimePublicBefore
  $env:LAURUM_LOCAL_SERVICE_KEY = $runtimeServiceBefore
  $ErrorActionPreference = $runtimePreviousErrorPreference
}
if ($runtimeExit -ne 0) { throw 'Local runtime tests failed' }
