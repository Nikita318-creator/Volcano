import UIKit
import FirebaseCore
import FirebaseMessaging
import AdjustSdk
import AppTrackingTransparency
import Network

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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    // Статус можно не обрабатывать, Adjust сам подхватит IDFA, если разрешат
                }
            }
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL, let deeplink = ADJDeeplink(deeplink: url) {
            // В v5 используем это для резолвинга ссылки
            Adjust.processDeeplink(deeplink)
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let deeplink = ADJDeeplink(deeplink: url) {
            Adjust.processDeeplink(deeplink)
        }
        return true
    }
    
    // MARK: - Adjust Delegates
    
    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
        guard let dict = attribution?.dictionary() as? [String: Any] else { return }
        
        Task {
            await BaseUseCase.shared.setConfigData(attribution: dict)
            UserDefaults.standard.set(true, forKey: "adjustRecived")
        }
    }

    func adjustDeferredDeeplinkReceived(_ deeplink: URL?) -> Bool {
        if let link = deeplink?.absoluteString {
            Task {
                await BaseUseCase.shared.setConfigData(deeplink: link)
                UserDefaults.standard.set(true, forKey: "adjustRecived")
            }
        }
        return true
    }

    func adjustDeeplinkResponse(_ deeplink: URL?) -> Bool {
        if let link = deeplink?.absoluteString {
            Task {
                await BaseUseCase.shared.setConfigData(deeplink: link)
                UserDefaults.standard.set(true, forKey: "adjustRecived")
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
        
        if !isConnectedToNetwork() {
            BaseUseCase.shared.finalDataImageString = ""
        }
        
        if let cached = UserDefaults.standard.string(forKey: "imageStringMainKey") {
            BaseUseCase.shared.finalDataImageString = cached
        } else if UserDefaults.standard.bool(forKey: "adjustRecived") {
            Task {
                await BaseUseCase.shared.setConfigData()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    private func isConnectedToNetwork() -> Bool {
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false
        
        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        _ = semaphore.wait(timeout: .now() + 0.5)
        monitor.cancel()
        
        return isConnected
    }
}
