package com.amwalpay.sdk

import android.app.Activity
import android.media.AudioManager
import android.media.ToneGenerator
import android.nfc.NfcAdapter
import android.util.Log
import com.amwal_pay.softpos.DeviceConfigs
import com.amwal_pay.softpos.ReceiptData
import com.amwal_pay.softpos.Result
import com.amwal_pay.softpos.SoftPosSDK
import com.amwal_pay.softpos.TransactionResult
import com.amwal_pay.softpos.client.Configuration
import com.amwal_pay.softpos.enums.TransactionType
import com.github.devnied.emvnfccard.model.EmvCard
import com.google.gson.JsonObject
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.Locale

class SoftPOS_SDK : FlutterPlugin, ActivityAware, MethodCallHandler{
    var nfcAdapter: NfcAdapter? = null
    var isScanning: Boolean = false
    var apiCall: MethodCall? = null
    var apiResult: MethodChannel.Result? = null
    lateinit var softPosSdk: SoftPosSDK
    private var activity: Activity? = null

    private var flutterState: FlutterState? = null
    private val deviceConfigs = DeviceConfigs(Configuration.STORE_PROFILE_ID, Configuration.KERNEL_PROFILE_ID)
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        val loader = FlutterLoader()
        flutterState = FlutterState(binding.applicationContext,
            binding.binaryMessenger,
            object : KeyForAssetFn {
                override fun get(asset: String?): String {
                    return loader.getLookupKeyForAsset(
                        asset!!
                    )
                }

            },
            object : KeyForAssetAndPackageName {
                override fun get(asset: String?, packageName: String?): String {
                    return loader.getLookupKeyForAsset(
                        asset!!, packageName!!
                    )
                }
            },
            binding.textureRegistry
        )
        softPosSdk = SoftPosSDK(binding.applicationContext)
        flutterState?.startListening(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        apiResult = result;

        if (flutterState == null || flutterState?.textureRegistry == null) {
            result.error("no_activity", "better_player plugin requires a foreground activity", null)
            return
        }

            when (call.method) {
                "init" -> {
                    initVac(result)
                    return
                }

                "listen" -> {
                    startPay(result, call)
                    return
                 }

                "terminate" -> {
                    terminate(result)
                    return
                 }
            }
            result.notImplemented()
        }

    private fun startPay(res: MethodChannel.Result, call: MethodCall) {
        apiCall = call
        val amount: Int = apiCall!!.argument("Amount")?:0
        if(activity == null){
            res.success(false)
            return
        }
        CoroutineScope(Dispatchers.IO).launch {
            softPosSdk?.pay(activity!!, amount, TransactionType.PURCHASE)?.collect {
                when (it) {
                    is TransactionResult.Approved -> withContext(Dispatchers.Main){
                        sendReceiptInfo(true,it.receiptData)
                    }

                    is TransactionResult.Declined -> withContext(Dispatchers.Main){
                        sendReceiptInfo(false,it.receiptData)
                    }

                    is TransactionResult.Failed -> withContext(Dispatchers.Main){
                        parsedError(it.error.message)
                    }

                    is TransactionResult.ShowMessage -> withContext(Dispatchers.Main){
                        var messageText = ""
                        for (message in it.message) {
                            messageText += message
                        }
                        parsedError(messageText)
                    }

                    is TransactionResult.Aborted -> {
                        parsedError(it.message)
                    }
                }
            }
        }
    }


    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        if (flutterState == null) {
            Log.wtf(TAG, "Detached from the engine before registering to it.")
        }
        flutterState?.stopListening()
        flutterState = null
        if (nfcAdapter != null) {
            nfcAdapter!!.disableReaderMode(activity)
            if (isScanning) {

            }
        }
    }


    private fun terminate(result: MethodChannel.Result) {

        result.success(true)
    }

    private fun initVac(res: MethodChannel.Result) {
        if(softPosSdk == null){
            res.success(0)
        }
        CoroutineScope(Dispatchers.IO).launch {
            softPosSdk?.initVacThinClient(deviceConfigs)?.collect { result ->
                when (result) {
                    is Result.Success -> withContext(Dispatchers.Main){
                        res.success(2)
                    }

                    is Result.InProgress -> withContext(Dispatchers.Main){

                    }

                    is Result.Error -> withContext(Dispatchers.Main){
                        res.success(1)
                    }

                    is Result.NotEligible -> {
                        var eMessage = ""
                        for (r in result.messages){
                            eMessage.plus("${r.message}\n")

                        }
                        res.success(1)
                    }
                }
            }
        }
    }

    private fun sendReceiptInfo(isApproved:Boolean, data: ReceiptData) {
        val jsonObject = JsonObject()
        jsonObject.addProperty("success", isApproved)
        jsonObject.addProperty("state", data.CompletionIndicator)
        jsonObject.addProperty("cardData", data.toString())
        try {
            jsonObject.addProperty("cardNumber", data.MaskedPANLast4)
            val outputFormat = SimpleDateFormat("MM/yy", Locale.ENGLISH)
            jsonObject.addProperty("cardExpiry",  outputFormat.format("**/**"))
        }catch (e : Exception){
            print(e);
        }
        apiResult?.success(jsonObject.toString())
    }

    private fun parsedError(message: String?): String? {
        ToneGenerator(AudioManager.STREAM_ALARM, 100).startTone(ToneGenerator.TONE_CDMA_ALERT_CALL_GUARD, 500)            // Send error

        val jsonObject: JsonObject = JsonObject()
        jsonObject.addProperty("success", false)
        jsonObject.addProperty("error", message)
        return jsonObject.toString()
    }

    companion object {
        val TAG: String = this.javaClass.simpleName

    }
}
