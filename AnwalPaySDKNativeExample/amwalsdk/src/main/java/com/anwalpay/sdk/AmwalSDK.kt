package com.anwalpay.sdk

import android.content.Context
import android.util.Log
import com.anwalpay.sdk.serializers.CurrencySerializer
import com.anwalpay.sdk.serializers.EnvironmentSerializer
import com.anwalpay.sdk.serializers.LocaleSerializer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import java.util.Locale

class AmwalSDK {

    companion object{
        const val ENGINE_ID = "engine_id"
        const val CHANNEL = "amwal.sdk/functions"
    }

    private var isEngineInitlized : Boolean = false
    private lateinit var flutterEngine : FlutterEngine


    fun start(context: Context,config: Config,onResponse: (String?) -> Unit , onCustomerId: (String?) -> Unit) {
        if (!isEngineInitlized){
            warmupEngine(context,onResponse,onCustomerId)
            isEngineInitlized = true
        }
        // Start executing Dart code to pre-warm the FlutterEngine.
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault(),listOf(config.toJsonString())
        )

        context.startActivity(
            FlutterActivity
                .withCachedEngine(ENGINE_ID)
                .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                .build(context)
        )
    }

    private fun warmupEngine(context: Context, onResponse: (String?) -> Unit, onCustomerId: (String?) -> Unit) {
        // Instantiate a FlutterEngine.
        flutterEngine = FlutterEngine(context)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                Log.d("NativeMethod", call.method)
                when (call.method) {
                    "onResponse"-> {
                        val response = call.argument<String?>("response")
                        onResponse(response)
                        result.success(0)
                    }
                    "onCustomerId"-> {
                        val customerId = call.argument<String?>("customerId")
                        onCustomerId(customerId)
                        result.success(0)
                    }
                    else -> result.notImplemented()
                }
            }

        // Cache the FlutterEngine to be used by FlutterActivity or FlutterFragment.
        FlutterEngineCache
            .getInstance()
            .put(ENGINE_ID, flutterEngine)
    }

    @Serializable
    data class Config(
        @Serializable(with = EnvironmentSerializer::class)
        val environment: Environment,
        val sessionToken: String,
        @Serializable(with = CurrencySerializer::class)
        val currency: Currency,
        val amount: String,
        val merchantId: String,
        val terminalId: String,
        val customerId: String?,
        @Serializable(with = LocaleSerializer::class)
        val locale: Locale,
        val isSoftPOS: Boolean
    ){

        fun toJsonString(): String {
            return Json.encodeToString(this)
        }

        enum class Environment { UAT, SIT, PROD }
        enum class Currency(val value: String) { OMR("omr") }
    }

}