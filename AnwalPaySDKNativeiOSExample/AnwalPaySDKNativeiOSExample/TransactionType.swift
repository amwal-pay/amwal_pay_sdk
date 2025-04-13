//
//  enum.swift
//  AnwalPaySDKNativeiOSExample
//
//  Created by Ahmed Ganna on 09.02.25.
//


// Define TransactionType enum
enum TransactionType: String, Codable,CaseIterable {
    case NFC
    case CARD_WALLET
    case APPLE_PAY
}
