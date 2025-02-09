//
//  conforming.swift
//  AnwalPaySDKNativeiOSExample
//
//  Created by Ahmed Ganna on 09.02.25.
//

import Foundation


// ViewModel class conforming to ObservableObject
class PaymentFormViewModel: ObservableObject {    
    
    @Published var merchantId: String = "116194"
    @Published var terminalId: String = "708393"
    @Published var amount: String = "1"
    @Published var currency: Config.Currency = .OMR
    @Published var language: Config.Locale = .en
    @Published var transactionType: TransactionType = .NFC
    @Published var secureHash: String = "2B03FCDC101D3F160744342BFBA0BEA0E835EE436B6A985BA30464418392C703"
    @Published var selectedEnv: Config.Environment = .UAT
        
}
