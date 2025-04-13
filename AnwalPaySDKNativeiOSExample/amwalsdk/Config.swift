//
//  Config.swift
//  AnwalPaySDKNativeiOSExample
//
//  Created by Ahmed Ganna on 09.02.25.
//

import Foundation

public class Config: Codable {
    public enum TransactionType: String, Codable, CaseIterable {
        case nfc
        case cardWallet
        case applePay
    }
    
    public enum Environment: String, Codable, CaseIterable {
        case UAT, SIT, PROD
    }
    
    public enum Currency: String, Codable, CaseIterable {
        case OMR = "omr"
    }
    
    public enum Locale: String, Codable, CaseIterable {
        case en = "en"
        case ar = "ar"
    }
    
    public var environment: Environment
    public var sessionToken: String
    public var currency: Currency
    public var amount: String
    public var merchantId: String
    public var terminalId: String
    public var customerId: String?
    public var locale: Locale
    public var transactionType: TransactionType
    
    public init(
        environment: Environment,
        sessionToken: String,
        currency: Currency,
        amount: String,
        merchantId: String,
        terminalId: String,
        customerId: String? = nil,
        locale: Locale,
        transactionType: TransactionType
    ) {
        self.environment = environment
        self.sessionToken = sessionToken
        self.currency = currency
        self.amount = amount
        self.merchantId = merchantId
        self.terminalId = terminalId
        self.customerId = customerId
        self.locale = locale
        self.transactionType = transactionType
    }
    
    public func toJsonString() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}
