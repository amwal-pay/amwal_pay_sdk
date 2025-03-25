//
//  FlutterViewControllerRepresentable.swift
//  AnwalPaySDKNativeiOSExample
//
//  Created by Ahmed Ganna on 09.02.25.
//


import SwiftUI
import Flutter
import amwalsdk
struct SDKViewControllerRepresentable: UIViewControllerRepresentable {
    var config: Config
    var onResponse: (String?) -> Void
    var onCustomerId: (String) -> Void
        
    func makeUIViewController(context: Context) -> UIViewController {
        do {
            // Create the FlutterViewController using AmwalSDK
            let sdk = AmwalSDK()
            return try sdk.createViewController(
                config: config,
                onResponse: onResponse,
                onCustomerId: onCustomerId
            )
        } catch {
            // Handle the error if creation fails (e.g., show a default or error view)
            print("Error creating FlutterViewController: \(error.localizedDescription)")
            return UIViewController() // Return an empty or error state view controller
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Handle updates to the UI if needed (e.g., pass new data to the controller)
    }
}
