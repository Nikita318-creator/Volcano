import UIKit
import SnapKit
import StoreKit

class GameVC: BaseGameVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UI Elements
    private let topPanel = UIView()
    private let pointsLabel = UILabel()
    private let levelLabel = UILabel()
    
    private lazy var startButton = createGameButton(title: "GO ON EXPEDITION", color: UIColor(red: 0.9, green: 0.4, blue: 0.1, alpha: 1.0))
    private lazy var collectionButton = createGameButton(title: "TROPHIES", color: UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0))
    private lazy var legendButton = createGameButton(title: "THE LEGEND", color: UIColor(red: 0.4, green: 0.3, blue: 0.7, alpha: 1.0))
    
    private lazy var rateButton = createGameButton(title: "RATE APP", color: .systemGreen)
    private lazy var shareButton = createGameButton(title: "SHARE APP", color: .systemTeal)
    private lazy var bgButton = createGameButton(title: "SET BACKGROUND", color: .systemGray)
    private lazy var privacyButton = createGameButton(title: "PRIVACY", color: .darkGray)

    // MARK: - Lifecycle
    init() {
        super.init(showBackButton: false)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedBackground()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
        showInterface(true)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        topPanel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        topPanel.layer.cornerRadius = 16
        topPanel.layer.borderWidth = 2
        topPanel.layer.borderColor = UIColor.systemYellow.cgColor
        
        view.addSubview(topPanel)
        topPanel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(80)
        }
        
        let stack = UIStackView(arrangedSubviews: [pointsLabel, levelLabel])
        stack.axis = .vertical
        stack.alignment = .center
        topPanel.addSubview(stack)
        stack.snp.makeConstraints { $0.center.equalToSuperview() }
        
        pointsLabel.textColor = .systemYellow
        pointsLabel.font = .systemFont(ofSize: 24, weight: .black)
        levelLabel.textColor = .white
        levelLabel.font = .systemFont(ofSize: 16, weight: .bold)

        let buttons = [startButton, collectionButton, legendButton, rateButton, shareButton, bgButton, privacyButton]
        let selectors: [Selector] = [
            #selector(startTapped), #selector(collectionTapped), #selector(legendTapped),
            #selector(rateApp), #selector(shareApp), #selector(changeBackground), #selector(showPrivacy)
        ]
        
        for (index, button) in buttons.enumerated() {
            view.addSubview(button)
            button.addTarget(self, action: selectors[index], for: .touchUpInside)
            button.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalTo(topPanel.snp.bottom).offset(25)
                } else {
                    make.top.equalTo(buttons[index-1].snp.bottom).offset(15)
                }
                make.centerX.equalToSuperview()
                make.width.equalTo(280)
                make.height.equalTo(index == 0 ? 70 : 52)
            }
        }
    }

    // MARK: - Reviewer Actions
    @objc private func rateApp() {
        if let scene = view.window?.windowScene { SKStoreReviewController.requestReview(in: scene) }
    }
    
    @objc private func shareApp() {
        let text = "Join me in Ice Fishing Expedition! 🎣\nhttps://apps.apple.com/app/id6761615098"
        present(UIActivityViewController(activityItems: [text], applicationActivities: nil), animated: true)
    }
    
    @objc private func showPrivacy() { present(PrivacyVC(), animated: true) }
    
    @objc private func changeBackground() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            self.bgImageView.image = img
            if let data = img.jpegData(compressionQuality: 0.5) {
                UserDefaults.standard.set(data, forKey: "saved_user_bg")
            }
        }
        picker.dismiss(animated: true)
    }
    
    private func loadSavedBackground() {
        if let data = UserDefaults.standard.data(forKey: "saved_user_bg"), let img = UIImage(data: data) {
            self.bgImageView.image = img
        }
    }

    // MARK: - Flow Logic
    @objc private func startTapped() {
        showInterface(false)
        presentStory()
    }
    
    @objc private func collectionTapped() {
        let collectionVC = CollectionVC()
        present(collectionVC, animated: true)
    }
    
    @objc private func legendTapped() {
        let backVC = BackstoryVC()
        backVC.modalPresentationStyle = .overFullScreen
        present(backVC, animated: true)
    }

    private func presentStory() {
        let storyVC = StoryVC()
        storyVC.modalPresentationStyle = .overFullScreen
        storyVC.onFinished = { [weak self] in
            storyVC.dismiss(animated: false) {
                self?.presentCorrectGame()
            }
        }
        storyVC.onDismissed = { [weak self] in
            self?.showInterface(true)
        }
        present(storyVC, animated: false)
    }

    private func presentCorrectGame() {
        let level = GameManager.shared.currentLevel
        let gameType = StoryEngine.gameType(for: level)
        
        let gameVC: UIViewController
        if gameType == .cards {
            let catchVC = CatchVC()
            catchVC.onGameFinished = { [weak self] in
                catchVC.dismiss(animated: false) { self?.handleWin() }
            }
            gameVC = catchVC
        } else {
            let drillVC = IceDrillVC()
            drillVC.onGameFinished = { [weak self] in
                drillVC.dismiss(animated: false) { self?.handleWin() }
            }
            gameVC = drillVC
        }
        
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: false)
    }

    private func handleWin() {
        GameManager.shared.levelUp()
        GameManager.shared.points += Int.random(in: 8...22)
        updateStats()
        
        if let trophy = GameManager.shared.checkTrophy() {
            let resultVC = ResultVC()
            resultVC.configure(with: trophy)
            present(resultVC, animated: false)
        } else {
            presentStory()
        }
    }

    private func showInterface(_ show: Bool) {
        let alpha: CGFloat = show ? 1.0 : 0.0
        UIView.animate(withDuration: 0.25) {
            self.topPanel.alpha = alpha
            [self.startButton, self.collectionButton, self.legendButton,
             self.rateButton, self.shareButton, self.bgButton, self.privacyButton].forEach { $0.alpha = alpha }
        }
    }
    
    private func updateStats() {
        pointsLabel.text = "POINTS: \(GameManager.shared.points)"
        levelLabel.text = "LEVEL: \(GameManager.shared.currentLevel)"
    }
}

// MARK: - Privacy View Controller
class PrivacyVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 14)
        textView.isEditable = false
        textView.text = """
        PRIVACY POLICY AND DATA PROTECTION
        Effective Date: April 2026
        
        1. General Information
        This Privacy Policy describes how we handles your personal information. We are committed to ensuring that your privacy is protected.
        
        2. Data Collection and Usage
        The App does not collect personally identifiable information such as your name, address, or phone number.
        
        3. Camera Access
        Our App includes a "Custom Background" feature that requires access to your device's camera. Photos taken are used solely locally for visual customization and are not transmitted to any servers.
        
        4. Third-Party Services
        We don’t collect device-identifying info. We only save your game progress and performance data.
        
        5. Contact Us
        If you have any questions, please contact our support team via App Store contact form.
        """
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(100)
        }
        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("CLOSE", for: .normal)
        closeBtn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        closeBtn.setTitleColor(.systemYellow, for: .normal)
        closeBtn.addTarget(self, action: #selector(dismissMe), for: .touchUpInside)
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    @objc func dismissMe() { dismiss(animated: true) }
}
