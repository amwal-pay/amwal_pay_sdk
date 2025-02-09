//
//  SecureHashUtil.swift
//  AnwalPaySDKNativeiOSExample
//
//  Created by Ahmed Ganna on 09.02.25.
//


import Foundation
import CommonCrypto

class SecureHashUtil {

    /// Removes the `secureHashValue` key from the dictionary, composes the data, and generates a secure hash.
    static func clearSecureHash(secretKey: String, data: inout [String: String?]) -> String {
        data.removeValue(forKey: "secureHashValue")
        let concatenatedString = composeData(requestParameters: data)
        return generateSecureHash(message: concatenatedString, secretKey: secretKey)
    }

    /// Composes the data into a sorted and concatenated string.
    private static func composeData(requestParameters: [String: String?]) -> String {
        guard !requestParameters.isEmpty else { return "" }

        // Sort the parameters by key in ascending order
        let sortedParameters = requestParameters
            .sorted { $0.key < $1.key }
            .filter { $0.value != nil } // Remove entries with nil values

        // Join the key-value pairs into a single string separated by `&`
        return sortedParameters
            .map { "\($0.key)=\($0.value!)" }
            .joined(separator: "&")
    }

    /// Generates a secure hash using HMAC-SHA256.
    private static func generateSecureHash(message: String, secretKey: String) -> String {
        guard let keyData = secretKey.hexToBytes() else { return "" }

        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyData, keyData.count, message, message.count, &digest)

        // Convert the digest to a hexadecimal string and uppercase it
        return digest.map { String(format: "%02x", $0) }.joined().uppercased()
    }
}

// MARK: - Helper Extension
extension String {
    /// Converts a hexadecimal string to a byte array.
    func hexToBytes() -> [UInt8]? {
        var hex = self
        if hex.count % 2 != 0 {
            hex = "0" + hex
        }

        var bytes = [UInt8]()
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            if let byte = UInt8(hex[index..<nextIndex], radix: 16) {
                bytes.append(byte)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
}
