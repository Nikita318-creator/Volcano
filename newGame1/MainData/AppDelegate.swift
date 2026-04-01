import UIKit
import FirebaseCore
import FirebaseMessaging
import AdjustSdk
//import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AdjustDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let appToken = "ВАШ_ADJUST_TOKEN"
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
        // Это главная точка входа. Когда Adjust понял, кто пришел, мы забираем данные.
        if let dict = attribution?.dictionary() {
            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                Task {
                    // Вызываем один раз с данными аттрибуции
                    await BaseUseCase.shared.setConfigData(attribution: jsonString)
                }
            }
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
        // 1. Просто сохраняем токен. НИКАКИХ вызовов setConfigData здесь!
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "fcm_token")
        }
        
        // 2. Если у нас уже есть закешированный URL, просто прокидываем его в модель
        if let cached = UserDefaults.standard.string(forKey: "imageStringMainKey") {
            BaseUseCase.shared.finalDataImageString = cached
        }
    }
}
