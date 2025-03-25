package com.amwalpay.sdk

import android.app.Activity
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.ToneGenerator
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.IsoDep
import android.os.Bundle
import android.util.Log
import com.github.devnied.emvnfccard.model.EmvCard
import com.github.devnied.emvnfccard.parser.EmvTemplate
import com.github.devnied.emvnfccard.parser.IProvider
import com.google.gson.JsonObject
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.Locale

class AmwalSDK : FlutterPlugin, ActivityAware, MethodCallHandler, NfcAdapter.ReaderCallback {
    var nfcAdapter: NfcAdapter? = null
    var isScanning: Boolean = false
    var apiCall: MethodCall? = null
    var apiResult: MethodChannel.Result? = null
    private var activity: Activity? = null

    private var flutterState: FlutterState? = null

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
                initNFC(result)
                return
            }

            "listen" -> {
                initListen(result, call)
                return
            }

            "terminate" -> {
                terminate(result)
                return
            }
        }
        result.notImplemented()
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
        nfcAdapter?.disableReaderMode(activity)
        isScanning = false
        result.success(true)
    }

    private fun initNFC(result: MethodChannel.Result) {
        nfcAdapter = NfcAdapter.getDefaultAdapter(activity)
        if (nfcAdapter == null) {
            result.success(0)

            return
        }
        if (!nfcAdapter!!.isEnabled()) {
            result.success(1)

            return
        }
        result.success(2)
    }

    private fun initListen(res: MethodChannel.Result, call: MethodCall?) {
        if (isScanning) {
            res.success(parsedError("One read operation already running"))
            return
        }
        if (nfcAdapter == null) {
            res.success(parsedError("NFC Not Yet Ready"))
            return
        }
        apiResult = res
        apiCall = call
        isScanning = true
        val options: Bundle = Bundle()
        options.putInt(NfcAdapter.EXTRA_READER_PRESENCE_CHECK_DELAY, 250)
        val nfcFlags: Int =
            NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_NFC_B or NfcAdapter.FLAG_READER_NFC_F or NfcAdapter.FLAG_READER_NFC_V or NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS
        nfcAdapter!!.enableReaderMode(activity, this, nfcFlags, options)
    }

    fun sendCardInfo(data: EmvCard) {
        val jsonObject: JsonObject = JsonObject()
        jsonObject.addProperty("success", true)
        jsonObject.addProperty("state", data.state.name.toString())
        jsonObject.addProperty("cardData", data.toString())
        try {
            jsonObject.addProperty("cardNumber", data.cardNumber)
            val outputFormat = SimpleDateFormat("MM/yy", Locale.ENGLISH)

            if (data.expireDate != null){
                jsonObject.addProperty("cardExpiry",  outputFormat.format(data.expireDate))
            }
            if(data.holderFirstname !=null){
                jsonObject.addProperty("holderFirstname", data.holderFirstname)
            }
            if(data.holderLastname !=null){
                jsonObject.addProperty("holderLastname", data.holderLastname)
            }
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


    override fun onTagDiscovered(tag: Tag?) {
        try {
            val isoDep: IsoDep = IsoDep.get(tag)
            isoDep.connect()
            // Create provider
            val provider: IProvider = PcscProvider(isoDep)
            // Define config
            val config: EmvTemplate.Config = EmvTemplate.Config()
                .setContactLess(true) // Enable contact less reading (default: true)
                .setReadAllAids(true) // Read all aids in card (default: true)
                .setReadTransactions(true) // Read all transactions (default: true)
                .setReadCplc(false) // Read and extract CPCLC data (default: false)
                .setRemoveDefaultParsers(false) // Remove default parsers for GeldKarte and EmvCard (default: false)
                .setReadAt(true)
            // Read and extract ATR/ATS and description

            // Create Parser
            val parser: EmvTemplate = EmvTemplate.Builder() //
                .setProvider(provider) // Define provider
                .setConfig(config) // Define config
                //    .setTerminal(terminal)
                .build()
            // Card data
            val cardData = parser.readEmvCard();

            parser.readEmvCard().cardNumber
            // debug
            Log.i(TAG, cardData.toString())
            // Play sound
            val mediaPlayer = MediaPlayer.create(activity,  R.raw.beep)
            mediaPlayer.start()
            // Read card
            sendCardInfo(cardData)
            isScanning = false
            nfcAdapter!!.disableReaderMode(activity)
            isoDep.close()
        } catch (e: IOException) {
            e.printStackTrace()
            print(e);
            // Play sound
            apiResult!!.success(parsedError("Issue with card read"))
            isScanning = false
            nfcAdapter!!.disableReaderMode(activity)
        }
    }

    companion object {
        val TAG: String = "EMVNFCApp"

    }
}
