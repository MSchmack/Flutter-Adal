import Flutter
import UIKit
import ADAL

public class SwiftFlutteradalPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutteradal", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutteradalPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getPlatformVersion") { 
      result("iOS " + UIDevice.current.systemVersion)
    } else if (call.method == "adalLoginSilent") {
        
  //      let args = call.arguments as? Dictionary<String, String>;
        
   //     let authority = "https://stfs.bosch.com/adfs"
      //  let resourceUrl = "https://stfs.bosch.com/adfs/userinfo"
    //    let clientId = args?["clientId"]
    //    let redirectUrl = "https://rb-portal.bosch.com"
        let args = call.arguments as? Dictionary<String, String>;
        
        let authority = args?["authority"]
        let clientId = args?["clientId"]
        let redirectUrl = args?["redirectUrl"]
        let resourceUrl = args?["resourceUrl"]
        
        
        let authContext = ADAuthenticationContext(authority: authority,
                                                  validateAuthority: false,
                                                  error: nil)
        authContext!.acquireTokenSilent(withResource: resourceUrl,
                                  clientId: clientId,
                                  redirectUri: URL(string: redirectUrl!))
        {
                        (value) in
                        
                        if (value!.status != AD_SUCCEEDED)
                        {
                            let myResultDict = [
                                "isSuccess": false,
                                "accessToken": "",
                                "refreshToken": "",
                                "expiresOn": "",
                                "errorType": "AD request not succeded"
                                ] as [String: Any];
                            result(myResultDict);
                            
                            return;
                        }
                        
                        var expiresOnString = "(nil)"
                        
                        if let expiresOn = value!.tokenCacheItem.expiresOn {
                            expiresOnString = String(describing: expiresOn)
                        }
                        
                        let myResultDict = [
                            "isSuccess": true,
                            "accessToken": value!.accessToken,
                            "expiresOn": expiresOnString,
                            "refreshToken": value!.tokenCacheItem.refreshToken,
                            "errorType": ""
                            ]  as [String: Any];
                        result(myResultDict);
        }
    } else {
        let args = call.arguments as? Dictionary<String, String>;
        
        let authority = args?["authority"]
        let clientId = args?["clientId"]
        let redirectUrl = args?["redirectUrl"]
        let resourceUrl = args?["resourceUrl"]
        
        
        let authContext = ADAuthenticationContext(authority: authority,
                                                  validateAuthority: false,
                                                  error: nil)
        authContext!.acquireToken(withResource: resourceUrl,
                                        clientId: clientId,
                                        redirectUri: URL(string: redirectUrl!))
        {
            (value) in
            
            if (value!.status != AD_SUCCEEDED)
            {
                //if result!.error.domain == ADAuthenticationErrorDomain
               //     && result!.error.code == ADErrorCode.ERROR_UNEXPECTED.rawValue {
                    
                //    self.updateStatusField("Unexpected internal error occured");
                    
               // } else {
                    
              //      self.updateStatusField(result!.error.description)
              //  }
                let myResultDict = [
                    "isSuccess": false,
                    "accessToken": "",
                    "refreshToken": "",
                    "expiresOn": "",
                    "errorType": "AD request not succeded"
                ] as [String: Any];
                result(myResultDict);
                
                return;
            }
            
            var expiresOnString = "(nil)"
            
            if let expiresOn = value!.tokenCacheItem.expiresOn {
                expiresOnString = String(describing: expiresOn)
            }
            
            let myResultDict = [
                "isSuccess": true,
                "accessToken": value!.accessToken,
                "expiresOn": expiresOnString,
                "refreshToken": value!.tokenCacheItem.refreshToken,
                "errorType": ""
            ]  as [String: Any];
            result(myResultDict);
    
        }
    } 
  }
}
