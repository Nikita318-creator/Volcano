import UIKit
import SnapKit

class GameVC: BaseGameVC {
    
    // MARK: - UI Elements
    private let topPanel = UIView()
    private let pointsLabel = UILabel()
    private let levelLabel = UILabel()
    
    private lazy var startButton = createGameButton(title: "START EXPEDITION", color: UIColor(red: 0.9, green: 0.4, blue: 0.1, alpha: 1.0))
    private lazy var collectionButton = createGameButton(title: "TROPHIES", color: UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0))
    private lazy var legendButton = createGameButton(title: "THE LEGEND", color: UIColor(red: 0.4, green: 0.3, blue: 0.7, alpha: 1.0))

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
            make.top.equalTo(startButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(55)
        }
        
        // Добавляем кнопку легенды
        legendButton.addTarget(self, action: #selector(legendTapped), for: .touchUpInside)
        view.addSubview(legendButton)
        legendButton.snp.makeConstraints { make in
            make.top.equalTo(collectionButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(55)
        }
    }
    
    @objc private func legendTapped() {
        let backVC = BackstoryVC()
        backVC.modalPresentationStyle = .overFullScreen
        present(backVC, animated: true)
    }
    
    // Скрываем/показываем все кнопки и статы разом
    private func showInterface(_ show: Bool) {
        let alpha: CGFloat = show ? 1.0 : 0.0
        UIView.animate(withDuration: 0.25) {
            self.topPanel.alpha = alpha
            self.startButton.alpha = alpha
            self.collectionButton.alpha = alpha
            self.legendButton.alpha = alpha // Теперь скрывается корректно
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
        // 1. Повышаем уровень
        GameManager.shared.levelUp()
        
        // 2. Начисляем рандомные поинты (от 8 до 22)
        let randomPoints = Int.random(in: 8...22)
        GameManager.shared.points += randomPoints
        
        // 3. Обновляем лейблы на главном экране
        updateStats()
        
        if let trophy = GameManager.shared.checkTrophy() {
            let resultVC = ResultVC()
            resultVC.configure(with: trophy)
            present(resultVC, animated: false)
        } else {
            // Если трофея нет, показываем следующую часть истории
            presentStory()
        }
    }
    
    @objc private func collectionTapped() {
        let collectionVC = CollectionVC()
        present(collectionVC, animated: false)
    }
}
