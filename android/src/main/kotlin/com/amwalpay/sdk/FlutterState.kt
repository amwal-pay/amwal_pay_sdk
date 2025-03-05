package com.amwalpay.sdk

import android.content.Context
import io.flutter.embedding.android.KeyData.CHANNEL
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.view.TextureRegistry

class FlutterState(
    val applicationContext: Context,
    val binaryMessenger: BinaryMessenger,
    val keyForAsset: KeyForAssetFn,
    val keyForAssetAndPackageName: KeyForAssetAndPackageName,
    val textureRegistry: TextureRegistry?
) {
    private val methodChannel: MethodChannel = MethodChannel(binaryMessenger, "com_amwalpay_sdk")

    fun startListening(methodCallHandler: MethodCallHandler?) {
        methodChannel.setMethodCallHandler(methodCallHandler)
    }

    fun stopListening() {
        methodChannel.setMethodCallHandler(null)
    }

}

interface KeyForAssetFn {
    operator fun get(asset: String?): String
}

interface KeyForAssetAndPackageName {
    operator fun get(asset: String?, packageName: String?): String
}