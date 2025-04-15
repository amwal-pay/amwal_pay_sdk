package com.anwalpay.sdk.serializers;

import com.anwalpay.sdk.AmwalSDK.Config.Currency
import com.anwalpay.sdk.AmwalSDK.Config.Environment
import com.anwalpay.sdk.AmwalSDK.Config.TransactionType
import kotlinx.serialization.KSerializer
import java.util.Locale;

import kotlinx.serialization.descriptors.PrimitiveKind;
import kotlinx.serialization.descriptors.PrimitiveSerialDescriptor
import kotlinx.serialization.descriptors.SerialDescriptor
import kotlinx.serialization.encoding.Decoder
import kotlinx.serialization.encoding.Encoder

/** Custom serializer for Locale */
object LocaleSerializer : KSerializer<Locale> {
    override val descriptor: SerialDescriptor = PrimitiveSerialDescriptor("Locale", PrimitiveKind.STRING)

    override fun serialize(encoder: Encoder, value:Locale) {
        encoder.encodeString(value.toLanguageTag())  // Convert Locale to "en-US"
    }

    override fun deserialize(decoder: Decoder): Locale {
        return Locale.forLanguageTag(decoder.decodeString())  // Convert back to Locale
    }
}

object CurrencySerializer : KSerializer<Currency> {
    override val descriptor: SerialDescriptor = PrimitiveSerialDescriptor("Currency", PrimitiveKind.STRING)

    override fun serialize(encoder: Encoder, value: Currency) {
        encoder.encodeString(value.value)  // Convert Currency to "USD"
    }

    override fun deserialize(decoder: Decoder): Currency {
        return Currency.valueOf(decoder.decodeString())  // Convert back to Currency
    }
}

object TransactionTypeSerializer : KSerializer<TransactionType> {
    override val descriptor: SerialDescriptor = PrimitiveSerialDescriptor("TransactionType", PrimitiveKind.STRING)

    override fun serialize(encoder: Encoder, value: TransactionType) {
        encoder.encodeString(value.value)  // Convert TransactionType to its string value
    }

    override fun deserialize(decoder: Decoder): TransactionType {
        return TransactionType.valueOf(decoder.decodeString())  // Convert back to TransactionType
    }
}

/** Custom serializer for Environment Enum */
object EnvironmentSerializer : KSerializer<Environment> {
    override val descriptor: SerialDescriptor = PrimitiveSerialDescriptor("Environment", PrimitiveKind.STRING)

    override fun serialize(encoder: Encoder, value: Environment) {
        encoder.encodeString(value.name.lowercase()) // Convert enum to lowercase string
    }

    override fun deserialize(decoder: Decoder): Environment {
        return Environment.valueOf(decoder.decodeString().uppercase()) // Convert back to enum
    }
}