import SwiftUI
import Flutter
import FlutterPluginRegistrant

class AmwalSDK {
    private var flutterEngine: FlutterEngine?

   func createViewController(
       config: Config,
       onResponse: @escaping (String?) -> Void,
       onCustomerId: @escaping (String) -> Void
   ) throws -> UIViewController {
       if flutterEngine == nil {
           let flutterProject = FlutterDartProject()
           flutterEngine = FlutterEngine(name: "engine_id", project: flutterProject)
       }

       do {
           let configJson = try config.toJsonString()
           let args = [configJson]

           guard let flutterEngine = flutterEngine else {
               throw NSError(domain: "amwalsdk", code: 5, userInfo: [NSLocalizedDescriptionKey: "FlutterEngine is not initialized."])
           }
           flutterEngine.run(withEntrypoint: nil)
       } catch {
           throw NSError(domain: "amwalsdk", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert config to JSON string: \(error.localizedDescription)"])
       }

       guard let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil) else {
           throw NSError(domain: "amwalsdk", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to initialize FlutterViewController."])
       }
       flutterViewController.modalPresentationStyle = .fullScreen

       let channel = FlutterMethodChannel(
           name: "amwal.sdk/functions",
           binaryMessenger: flutterEngine.binaryMessenger
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

       GeneratedPluginRegistrant.register(with: flutterEngine)

       return flutterViewController
   }

}
