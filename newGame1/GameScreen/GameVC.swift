
import UIKit
import SnapKit

class GameVC: BaseGameVC {
    
    private let topPanel = UIView()
    private let pointsLabel = UILabel()
    private let levelLabel = UILabel()
    
    private lazy var startButton = createGameButton(title: "START EXPEDITION", color: UIColor(red: 0.9, green: 0.4, blue: 0.1, alpha: 1.0))
    private lazy var collectionButton = createGameButton(title: "TROPHIES", color: UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0))
    
    init() {
        super.init(showBackButton: false) // На главном экране кнопка "назад" не нужна
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
    }
    
    private func setupUI() {
        // Плашка со статами в стиле казино (темная подложка, золотой текст)
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
        
        pointsLabel.textColor = .systemYellow
        pointsLabel.font = .systemFont(ofSize: 24, weight: .black)
        pointsLabel.textAlignment = .center
        
        levelLabel.textColor = .white
        levelLabel.font = .systemFont(ofSize: 16, weight: .bold)
        levelLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [pointsLabel, levelLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        
        topPanel.addSubview(stack)
        stack.snp.makeConstraints { $0.center.equalToSuperview() }
        
        // Кнопки
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
    
    private func updateStats() {
        pointsLabel.text = "POINTS: \(GameManager.shared.points)"
        levelLabel.text = "DEPTH LEVEL: \(GameManager.shared.currentLevel)"
    }
    
    @objc private func startTapped() {
        let storyVC = StoryVC()
        present(storyVC, animated: true)
    }
    
    @objc private func collectionTapped() {
        let collectionVC = CollectionVC()
        present(collectionVC, animated: true)
    }
}
