import Flutter

public class SwiftSecureStoragePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "secure_storage", binaryMessenger: registrar.messenger())
    let instance = SwiftSecureStoragePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let method = call.method
    let arguments: [String : String]? = call.arguments as? [String : String]
    let bundleID = Bundle.main.bundleIdentifier
    
    guard   let arguments = arguments,
            let account = arguments["keyType"],
            let bundleId = bundleID
    else {
      result(FlutterError(code: "Unavailable" ,message: "arguments, account, or bundleId is null", details: ""))
      return
    }
    
    let service = String(bundleId)
    
    if (method == "setKey") {
      
      guard let passsword = arguments["key"],
            let passwordData = passsword.data(using: .utf8)
      else {
        result(FlutterError(code: "SetKeyUnavailable" ,message: "Password or Password Data is null", details: ""))
        return
      }
      
      do {
        try KeychainInterface.save(
          password: passwordData,
          service: service,
          account: account
        )
        
        result(nil)
        
      } catch KeychainError.duplicateItem {
        
        do {
          try KeychainInterface.update(
            password: passwordData,
            service: service,
            account: account
          )
          
          result(nil)
        } catch let error {
          result(FlutterError(code: "SetKeyUnavailable" ,message: error.localizedDescription, details: ""))
        }
        
      } catch let error {
        result(FlutterError(code: "SetKeyUnavailable" ,message: error.localizedDescription, details: ""))
      }
      
    } else if (method == "deleteKey") {
      do {
        try KeychainInterface.deletePassword(service: service, account: account)
        result(nil)

      } catch KeychainError.itemNotFound {
        result(nil)
      } catch let error {
        result(FlutterError(code: "DeleteKeyUnavailable" ,message: error.localizedDescription, details: ""))
      }
    } else if (method == "getKey") {
      do {
        let passwordData = try KeychainInterface.readPassword(service: service, account: account)
        let password = String(data: passwordData, encoding: .utf8)
        result(password)
      } catch KeychainError.itemNotFound {
        result(nil)
      } catch let error {
        result(FlutterError(code: "GetKeyUnavailable" ,message: error.localizedDescription, details: ""))
      }
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
