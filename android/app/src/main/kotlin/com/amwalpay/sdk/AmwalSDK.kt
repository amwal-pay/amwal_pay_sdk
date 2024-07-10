package com.amwalpay.sdk

import android.media.AudioManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class AmwalSDK : FlutterPlugin, ActivityAware, MethodCallHandler, NfcAdapter.ReaderCallback {
    var nfcAdapter: NfcAdapter? = null
    var isScanning: Boolean = false
    var apiResult: Result? = null
    var apiCall: MethodCall? = null

    @Override
    fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine?) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "init" -> {
                    initNFC(result)
                    return@setMethodCallHandler
                }

                "listen" -> {
                    initListen(result, call)
                    return@setMethodCallHandler
                }

                "terminate" -> {
                    terminate(result)
                    return@setMethodCallHandler
                }
            }
            result.notImplemented()
        }
    }

    private fun terminate(res: Result?) {
        if (nfcAdapter != null) {
            nfcAdapter.disableReaderMode(this)
        }
        isScanning = false
        res.success(true)
    }

    private fun initNFC(res: Result?) {
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
        if (nfcAdapter == null) {
            res.success(0)
            return
        }
        if (!nfcAdapter.isEnabled()) {
            res.success(1)
            return
        }
        res.success(2)
    }

    private fun initListen(res: Result?, call: MethodCall?) {
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
        nfcAdapter.enableReaderMode(this, this, nfcFlags, options)
    }

    fun sendCardInfo(data: String?) {
        val jsonObject: JsonObject = JsonObject()
        jsonObject.addProperty("success", true)
        jsonObject.addProperty("cardData", data)
        apiResult.success(jsonObject.toString())
    }

    private fun parsedError(message: String?): String? {
        val jsonObject: JsonObject = JsonObject()
        jsonObject.addProperty("success", false)
        jsonObject.addProperty("error", message)
        return jsonObject.toString()
    }

    @Override
    fun onTagDiscovered(tag: Tag?) {
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
                //.setTerminal(terminal) (optional) you can define a custom terminal implementation to create APDU
                .build()
            // Card data
            val cardData: String = String.valueOf(parser.readEmvCard())
            // debug
            Log.i(TAG, cardData)
            // Play sound
            ToneGenerator(AudioManager.STREAM_MUSIC, 100).startTone(ToneGenerator.TONE_DTMF_P, 500)
            // Read card
            sendCardInfo(cardData)
            isScanning = false
            nfcAdapter.disableReaderMode(this)
            isoDep.close()
        } catch (e: IOException) {
            e.printStackTrace()
            // Play sound
            ToneGenerator(AudioManager.STREAM_MUSIC, 100).startTone(ToneGenerator.TONE_DTMF_P, 500)
            // Send error
            apiResult.success(parsedError("Issue with card read"))
            isScanning = false
            nfcAdapter.disableReaderMode(this)
        }
    }

    @Override
    fun onPointerCaptureChanged(hasCapture: Boolean) {
        super.onPointerCaptureChanged(hasCapture)
    }

    @Override
    protected fun onPause() {
        super.onPause()
        if (nfcAdapter != null) {
            nfcAdapter.disableReaderMode(this)
            if (isScanning) {
                finish()
            }
        }
    }

    companion object {
        val TAG: String? = "EMVNFCApp"
        private val CHANNEL: String? = "com.example.emv_sample"
    }
}
