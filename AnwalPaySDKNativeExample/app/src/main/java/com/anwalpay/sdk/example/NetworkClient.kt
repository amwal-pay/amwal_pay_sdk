package com.anwalpay.sdk.example;

import android.content.Context
import com.anwalpay.sdk.AmwalSDK
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject

class NetworkClient(private val context: Context) {

    private val client = OkHttpClient()

    suspend fun fetchSessionToken(
        env: AmwalSDK.Config.Environment,
        merchantId: String,
        customerId: String?,
        secureHashValue: String
    ): String? {
        val webhookUrl = when (env) {
            AmwalSDK.Config.Environment.SIT -> "https://test.amwalpg.com:24443/"
            AmwalSDK.Config.Environment.UAT -> "https://test.amwalpg.com:14443/"
            AmwalSDK.Config.Environment.PROD -> "https://webhook.amwalpg.com/"
        }

        return withContext(Dispatchers.IO) {
            try {
                val dataMap = mutableMapOf(
                    "merchantId" to merchantId,
                    "customerId" to customerId
                )

                val secureHash = SecureHashUtil.clearSecureHash(secureHashValue, dataMap)

                val jsonBody = JSONObject().apply {
                    put("merchantId", merchantId)
                    put("secureHashValue", secureHash)
                    put("customerId", customerId)
                }

                val requestBody = jsonBody.toString().toRequestBody("application/json".toMediaTypeOrNull())

                val request = Request.Builder()
                    .url("${webhookUrl}Membership/GetSDKSessionToken")
                    .header("accept", "text/plain")
                    .header("accept-language", "en-US,en;q=0.9")
                    .header("content-type", "application/json")
                    .post(requestBody)
                    .build()

                val response = client.newCall(request).execute()
                val responseBody = response.body?.string()

                if (response.isSuccessful && responseBody != null) {
                    val jsonResponse = JSONObject(responseBody)
                    if (jsonResponse.optBoolean("success")) {
                        return@withContext jsonResponse.getJSONObject("data").getString("sessionToken")
                    }
                } else {
                    val errorMessage = JSONObject(responseBody ?: "{}").optJSONArray("errorList")?.join(",") ?: "Unknown error"
                    showErrorDialog(errorMessage)
                }
            } catch (e: Exception) {
                showErrorDialog("Something Went Wrong")
            }
            return@withContext null
        }
    }

    private suspend fun showErrorDialog(message: String) {
        withContext(Dispatchers.Main) {
            android.app.AlertDialog.Builder(context)
                .setTitle("Error")
                .setMessage(message)
                .setPositiveButton("OK", null)
                .show()
        }
    }
}
