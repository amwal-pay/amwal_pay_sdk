//
//  AnwalPaySDKNativeiOSExampleApp.swift
//  AnwalPaySDKNativeiOSExample
//
//  Created by Ahmed Ganna on 06.02.25.
//

import SwiftUI
import amwalsdk
@main
struct AnwalPaySDKNativeiOSExampleApp: App {

    private let networkClient = NetworkClient()
    @State private var config: Config?
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                FormView(onSubmit:  { viewModel in
                    startSdk(viewModel: viewModel)
                })
                .navigationDestination(isPresented: Binding<Bool>(
                    get: { config != nil },
                    set: { if !$0 { config = nil } }
                )) {
                                   if let config = config {
                                       SDKViewControllerRepresentable(
                                           config: config,
                                           onResponse: { _ in },
                                           onCustomerId: { _ in }
                                       ) .navigationBarHidden(true)
                                   }
                               }
            }
        }
    }
    
    func startSdk(viewModel: PaymentFormViewModel) {
        networkClient.fetchSessionToken(
            env: .UAT,
            merchantId: viewModel.merchantId,
            customerId: nil,
            secureHashValue: viewModel.secureHash
        ) { [self] sessionToken in
            if let token = sessionToken {
                
                print("Session token: \(token)")
                
                // Map the UI transaction type to the SDK transaction type
                let sdkTransactionType: Config.TransactionType
                switch viewModel.transactionType {
                case .NFC:
                    sdkTransactionType = .nfc
                case .CARD_WALLET:
                    sdkTransactionType = .cardWallet
                case .APPLE_PAY:
                    sdkTransactionType = .applePay
                }
                
                config = Config(
                    environment: viewModel.selectedEnv,
                    sessionToken: token,
                    currency: viewModel.currency,
                    amount: viewModel.amount,
                    merchantId: viewModel.merchantId,
                    terminalId: viewModel.terminalId,
                    locale: viewModel.language,
                    transactionType: sdkTransactionType
                )
                                
            } else {
                print("Failed to fetch session token.")
            }
        }
    }
}
