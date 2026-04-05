import UIKit
import FirebaseCore
import FirebaseMessaging
import AdjustSdk
//import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AdjustDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let appToken = "7xke2b95hb7k"
        let environment = ADJEnvironmentProduction
        let adjustConfig = ADJConfig(appToken: appToken, environment: environment)
        adjustConfig?.delegate = self
        
        if let config = adjustConfig {
            Adjust.initSdk(config)
        }
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // 1. Запрос пушей
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
            // 2. Сразу после пушей запрашиваем IDFA (Tracking)
            // Делаем небольшую задержку, чтобы алерты не накладывались друг на друга
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                ATTrackingManager.requestTrackingAuthorization { status in
//                    // Статус можно не обрабатывать, Adjust сам подхватит IDFA, если разрешат
//                }
//            }
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: - Adjust Delegates
    
    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
        guard let dict = attribution?.dictionary() as? [String: Any] else { return }
        
        Task {
            await BaseUseCase.shared.setConfigData(attribution: dict)
        }
    }

    func adjustDeferredDeeplinkReceived(_ deeplink: URL?) -> Bool {
        if let link = deeplink?.absoluteString {
            Task {
                await BaseUseCase.shared.setConfigData(deeplink: link)
            }
        }
        return true
    }

    func adjustDeeplinkResponse(_ deeplink: URL?) -> Bool {
        if let link = deeplink?.absoluteString {
            Task {
                await BaseUseCase.shared.setConfigData(deeplink: link)
            }
        }
        return true
    }
}

// MARK: - Firebase Messaging
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "fcm_token")
        }
        
        print(BaseUseCase.shared.finalDataImageString)
        if let cached = UserDefaults.standard.string(forKey: "imageStringMainKey") {
            BaseUseCase.shared.finalDataImageString = cached
        }
    }
}
