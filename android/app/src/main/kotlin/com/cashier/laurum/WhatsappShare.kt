package com.cashier.laurum

import android.app.Activity
import android.content.ClipData
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.plugin.common.MethodCall
import java.io.File

object WhatsappShare {
    fun open(activity: Activity, call: MethodCall): Boolean {
        val phone = call.argument<String>("phone").orEmpty()
        val message = call.argument<String>("message").orEmpty()
        val image = call.argument<ByteArray>("image")
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = if (image == null) "text/plain" else "image/png"
            putExtra(Intent.EXTRA_TEXT, message)
            // WhatsApp may still ask users to confirm/select the recipient.
            if (phone.isNotEmpty()) putExtra("jid", "$phone@s.whatsapp.net")
        }
        return try {
            if (image != null) {
                val directory = File(activity.cacheDir, "whatsapp_receipts").apply { mkdirs() }
                // Remove old receipts; keep recent files while WhatsApp reads them.
                directory.listFiles()?.filter { System.currentTimeMillis() - it.lastModified() > 86400000 }
                    ?.forEach { it.delete() }
                val file = File.createTempFile("struk-", ".png", directory).apply { writeBytes(image) }
                val uri = FileProvider.getUriForFile(activity, "${activity.packageName}.receipts", file)
                intent.putExtra(Intent.EXTRA_STREAM, uri)
                intent.clipData = ClipData.newRawUri("Struk", uri)
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            val packages = listOf("com.whatsapp", "com.whatsapp.w4b")
            val candidates = packages.mapNotNull {
                if (image == null && message.isEmpty()) activity.packageManager.getLaunchIntentForPackage(it)
                else Intent(intent).setPackage(it)
            }
                .filter { it.resolveActivity(activity.packageManager) != null }
            if (candidates.isEmpty()) return false
            if (candidates.size == 1) activity.startActivity(candidates.first())
            else activity.startActivity(Intent.createChooser(candidates.first(), "WhatsApp")
                .putExtra(Intent.EXTRA_INITIAL_INTENTS, candidates.drop(1).toTypedArray()))
            true
        } catch (_: Exception) {
            false
        }
    }
}
