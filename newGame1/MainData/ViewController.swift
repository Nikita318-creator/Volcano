import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var splashVC: StartVC?
    private var dataCheckTimer: Timer?
    private var deadlineTimer: Timer?
    
    private let backButton = UIButton(type: .system)
    private let forwardButton = UIButton(type: .system)
    private let navigationContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
        view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if splashVC == nil {
            showSplashScreen()
            startDataCheckTimer()
            startDeadlineTimer() // Запускаем отсчет 3 секунд
        }
    }
    
    private func showMainInterface() {
        let tabbarVC = MainTabBarController()
        tabbarVC.modalPresentationStyle = .fullScreen
        present(tabbarVC, animated: true)
    }
    
    private func showSplashScreen() {
        let splash = StartVC()
        addChild(splash)
        splash.view.frame = view.bounds
        view.addSubview(splash.view)
        splash.didMove(toParent: self)
        self.splashVC = splash
    }
    
    private func dismissSplashScreen() {
        guard let splash = splashVC else { return }
        
        // Останавливаем ОБА таймера
        dataCheckTimer?.invalidate()
        dataCheckTimer = nil
        deadlineTimer?.invalidate()
        deadlineTimer = nil
        
        UIView.animate(withDuration: 0.3, animations: {
            splash.view.alpha = 0
        }, completion: { _ in
            splash.willMove(toParent: nil)
            splash.view.removeFromSuperview()
            splash.removeFromParent()
            self.splashVC = nil
            
            self.loadMainContent()
        })
    }
    
    // Таймер проверки данных (каждые 0.5 сек)
    private func startDataCheckTimer() { }
    
    // Таймер-предохранитель (3 секунды)
    private func startDeadlineTimer() {
        deadlineTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            print("⏳ Deadline reached. Moving forward regardless of data.")
            self?.dismissSplashScreen()
        }
    }
    
    private func loadMainContent() {
        // Если через 3 секунды данных все еще нет — идем в игру
        showMainInterface()
    }
}
