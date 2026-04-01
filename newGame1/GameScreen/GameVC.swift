import UIKit
import SnapKit

class GameVC: BaseGameVC {
    
    // MARK: - UI Elements
    private let topPanel = UIView()
    private let pointsLabel = UILabel()
    private let levelLabel = UILabel()
    
    private lazy var startButton = createGameButton(title: "START EXPEDITION", color: UIColor(red: 0.9, green: 0.4, blue: 0.1, alpha: 1.0))
    private lazy var collectionButton = createGameButton(title: "TROPHIES", color: UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0))
    
    // MARK: - Lifecycle
    init() {
        super.init(showBackButton: false)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
        // Когда возвращаемся из игры или экрана трофеев — плавно проявляем меню
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

        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(70)
        }
        
        collectionButton.addTarget(self, action: #selector(collectionTapped), for: .touchUpInside)
        view.addSubview(collectionButton)
        collectionButton.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(60)
        }
    }
    
    // Скрываем/показываем все кнопки и статы разом
    private func showInterface(_ show: Bool) {
        let alpha: CGFloat = show ? 1.0 : 0.0
        UIView.animate(withDuration: 0.25) {
            self.topPanel.alpha = alpha
            self.startButton.alpha = alpha
            self.collectionButton.alpha = alpha
        }
    }
    
    private func updateStats() {
        pointsLabel.text = "POINTS: \(GameManager.shared.points)"
        levelLabel.text = "LEVEL: \(GameManager.shared.currentLevel)"
    }
    
    // MARK: - Flow Logic
    @objc private func startTapped() {
        showInterface(false) // Кнопки исчезли, остался только фон BaseGameVC
        presentStory()
    }
    
    private func presentStory() {
        let storyVC = StoryVC()
        storyVC.modalPresentationStyle = .overFullScreen
        storyVC.onFinished = { [weak self] in
            storyVC.dismiss(animated: false) {
                self?.presentCorrectGame()
            }
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
        updateStats()
        
        if let trophy = GameManager.shared.checkTrophy() {
            let resultVC = ResultVC()
            resultVC.configure(with: trophy)
            present(resultVC, animated: false)
        } else {
            // Если идем дальше, кнопки по-прежнему невидимы (alpha = 0)
            presentStory()
        }
    }
    
    @objc private func collectionTapped() {
        let collectionVC = CollectionVC()
        present(collectionVC, animated: false)
    }
}
