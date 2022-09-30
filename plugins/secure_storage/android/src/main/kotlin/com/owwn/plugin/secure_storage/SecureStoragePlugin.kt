package com.owwn.plugin.secure_storage

import android.content.Context
import android.content.SharedPreferences
import androidx.annotation.NonNull
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKeys

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SecureStoragePlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  private var masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC)
  private lateinit var sharedPreferences : SharedPreferences

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    sharedPreferences = EncryptedSharedPreferences.create(
      "zapdefi_secure_storage",
      masterKeyAlias,
      context,
      EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
      EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
    )
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "secure_storage")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val method = call.method
    val arguments = call.arguments as Map<*, *>
    val keyType = arguments["keyType"] as String
    when (method) {
        "setKey" -> {
          val key = arguments["key"] as String?
          sharedPreferences.edit().putString(keyType, key).apply()
          result.success(null)
        }
        "deleteKey" -> {
          sharedPreferences.edit().remove(keyType).apply()
          result.success(null)
        }
        "getKey" -> {
          val key = sharedPreferences.getString(keyType, null)
          result.success(key)
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
