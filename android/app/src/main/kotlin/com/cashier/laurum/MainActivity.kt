package com.cashier.laurum

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.net.Uri
import android.provider.Settings

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "laurum/whatsapp")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "share" -> result.success(WhatsappShare.open(this, call))
                    "settings" -> {
                        startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                            Uri.fromParts("package", packageName, null)))
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
