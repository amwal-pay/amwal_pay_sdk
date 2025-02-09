//
//  AnwalPaySDKNativeiOSExampleApp.swift
//  AnwalPaySDKNativeiOSExample
//
//  Created by Ahmed Ganna on 06.02.25.
//

import SwiftUI

@main
struct AnwalPaySDKNativeiOSExampleApp: App {

    private let networkClient = NetworkClient()

    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                FormView(onSubmit:  { viewModel in
                
                    networkClient.fetchSessionToken(
                        env: .UAT,
                        merchantId: viewModel.merchantId,
                        customerId: nil,
                        secureHashValue: viewModel.secureHash
                    ) { [self] sessionToken in
                        if let token = sessionToken {
                            
                            print("Session token: \(token)")
                            let config = Config(environment: viewModel.selectedEnv, sessionToken: token, currency: viewModel.currency, amount: viewModel.amount, merchantId: viewModel.merchantId, terminalId: viewModel.terminalId, locale: viewModel.language, isSoftPOS: viewModel.transactionType == .NFC)
                            
                            SDKViewControllerRepresentable(config: config,onResponse: {_ in },onCustomerId: {_ in })
                            
                            
                        }else {
                            print("Failed to fetch session token.")
                        }
                    }
                    
                })
            }
        }
    }
}
