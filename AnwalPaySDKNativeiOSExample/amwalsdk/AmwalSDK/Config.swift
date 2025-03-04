//
//  Config.swift
//  AnwalPaySDKNativeiOSExample
//
//  Created by Ahmed Ganna on 09.02.25.
//


import Foundation

struct Config: Codable {
    enum Environment: String, Codable,CaseIterable {
        case UAT, SIT, PROD
    }
    
    enum Currency: String, Codable,CaseIterable {
        case OMR = "omr"
    }
    
    enum Locale: String, Codable,CaseIterable {
        case en = "en"
        case ar = "ar"
    }
    
    var environment: Environment
    var sessionToken: String
    var currency: Currency
    var amount: String
    var merchantId: String
    var terminalId: String
    var customerId: String?
    var locale: Locale
    var isSoftPOS: Bool
    
    func toJsonString() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}
