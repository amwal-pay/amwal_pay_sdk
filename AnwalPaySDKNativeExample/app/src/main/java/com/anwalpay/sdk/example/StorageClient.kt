package com.anwalpay.sdk.example;

import android.content.Context
import android.content.SharedPreferences

object StorageClient {
    private const val PREF_NAME = "user_prefs"
    private const val CUSTOMER_ID_KEY = "customer_id"


    private fun getPrefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
    }

    // Save Customer ID in SharedPreferences and update static variable
    fun saveCustomerId(context: Context, customerId: String?) {
        getPrefs(context).edit().putString(CUSTOMER_ID_KEY, customerId).apply()
    }

    // Retrieve Customer ID (from memory first, then SharedPreferences)
    fun getCustomerId(context: Context): String? {
       return getPrefs(context).getString(CUSTOMER_ID_KEY, null)
    }
}
