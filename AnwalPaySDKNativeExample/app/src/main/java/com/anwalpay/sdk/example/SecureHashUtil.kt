package com.anwalpay.sdk.example;
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

object SecureHashUtil {

    fun clearSecureHash(secretKey: String, data: MutableMap<String, String?>): String {
        data.remove("secureHashValue")
        val concatenatedString = composeData(data)
        return generateSecureHash(concatenatedString, secretKey)
    }

    private fun composeData(requestParameters:Map<String, String?>): String {
        return requestParameters.entries
            .sortedBy { it.key }
            .filter { !it.value.isNullOrEmpty()}
            .joinToString("&") { "${it.key}=${it.value}" }
    }

    private fun generateSecureHash(message: String, secretKey: String): String {
        return try {
            val keyBytes = secretKey.chunked(2)
                .map { it.toInt(16).toByte() }
                .toByteArray()

            val mac = Mac.getInstance("HmacSHA256")
            val secretKeySpec = SecretKeySpec(keyBytes, "HmacSHA256")
            mac.init(secretKeySpec)

            val hashBytes = mac.doFinal(message.toByteArray())
            hashBytes.joinToString("") { "%02x".format(it) }.uppercase()
        } catch (e: Exception) {
            ""
        }
    }
}
