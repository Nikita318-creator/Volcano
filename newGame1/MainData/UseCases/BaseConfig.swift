import UIKit
import WebKit
import AdjustSdk

class BaseConfig {
    func collectCoreData(deeplink: String? = nil, attribution: [String: Any]? = nil) async -> CoreConfigData {
        let appId = Bundle.main.bundleIdentifier ?? ""
        let pushToken = UserDefaults.standard.string(forKey: "fcm_token")
        let deviceID = await Adjust.adid()
        let adId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let userAgent: String = await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                let webView = WKWebView(frame: .zero)
                webView.evaluateJavaScript("navigator.userAgent") { (result, _) in
                    continuation.resume(returning: result as? String ?? "")
                }
            }
        }
        
        return CoreConfigData(
            appId: appId,
            pushToken: pushToken,
            userAgent: userAgent,
            deviceID: deviceID,
            adId: adId,
            oneLink: deeplink,
            naming: attribution
        )
    }
}

struct CoreConfigData {
    let appId: String
    let pushToken: String?
    let userAgent: String
    let deviceID: String?      // Adjust ADID
    let adId: String           // IDFV
    var oneLink: String?       // Deeplink
    var naming: [String: Any]?        // Attribution JSON
}
