package com.amwalpay.sdk


import android.nfc.tech.IsoDep
import com.github.devnied.emvnfccard.exception.CommunicationException
import com.github.devnied.emvnfccard.parser.IProvider
import java.io.IOException

class PcscProvider internal constructor(tag: IsoDep?) : IProvider {
    private var mTagCom: IsoDep?

    init {
        mTagCom = tag
    }


    @Throws(CommunicationException::class)
    override fun transceive(pCommand: ByteArray?): ByteArray? {
        val response: ByteArray
        try {
            // send command to emv card
            response = mTagCom!!.transceive(pCommand)
        } catch (e: IOException) {
            throw CommunicationException(e.toString())
        }
        return response
    }

    @Override
    override fun getAt(): ByteArray? {
        // For NFC-A
        return mTagCom?.getHistoricalBytes()
        // For NFC-B
        // return mTagCom.getHiLayerResponse();
    }

    fun setmTagCom(mTagCom: IsoDep?) {
        this.mTagCom = mTagCom
    }
}