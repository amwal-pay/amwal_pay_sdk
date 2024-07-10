package com.amwalpay.sdk


import android.nfc.tech.IsoDep

class PcscProvider internal constructor(tag: IsoDep?) : IProvider {
    private var mTagCom: IsoDep?

    init {
        mTagCom = tag
    }

    @Override
    @Throws(CommunicationException::class)
    fun transceive(pCommand: ByteArray?): ByteArray? {
        val response: ByteArray
        try {
            // send command to emv card
            response = mTagCom.transceive(pCommand)
        } catch (e: IOException) {
            throw CommunicationException(e.getMessage())
        }
        return response
    }

    @Override
    fun getAt(): ByteArray? {
        // For NFC-A
        return mTagCom.getHistoricalBytes()
        // For NFC-B
        // return mTagCom.getHiLayerResponse();
    }

    fun setmTagCom(mTagCom: IsoDep?) {
        this.mTagCom = mTagCom
    }
}