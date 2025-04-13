//
//  AmwalSDK.swift
//  
//
//  Created by Ahmed Ganna on 08.02.25.
//


import SwiftUI
import Flutter
import FlutterPluginRegistrant

public class AmwalSDK {
    private var flutterEngine: FlutterEngine?
    public init() {
        // Any initialization code if needed
    }

    public func createViewController(
        config:Config,
        onResponse: @escaping (String?) -> Void,
        onCustomerId: @escaping (String) -> Void
    ) throws -> UIViewController {
        
        if flutterEngine == nil {
            flutterEngine = FlutterEngine(name: "engine_id")
        }
        
        do {
            let configJson = try config.toJsonString()
            let args = [configJson]
            flutterEngine?.run(withEntrypoint: nil, libraryURI: nil, initialRoute: nil, entrypointArgs: args)
        } catch {
            throw NSError(domain: "amwalsdk", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert config to JSON string: \(error.localizedDescription)"])
        }
        
        // Set up a method channel for communication
        let channel = FlutterMethodChannel(
            name: "amwal.sdk/functions",
            binaryMessenger: flutterEngine!.binaryMessenger
        )

        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "onResponse":
                if let response = call.arguments as? String {
                    onResponse(response)
                } else {
                    onResponse(nil)
                }
            case "onCustomerId":
                if let customerId = call.arguments as? String {
                    onCustomerId(customerId)
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: flutterEngine!)

        let flutterViewController = FlutterViewController(engine: flutterEngine!, nibName: nil, bundle: nil)
        flutterViewController.modalPresentationStyle = .fullScreen

        return flutterViewController
    }
}
