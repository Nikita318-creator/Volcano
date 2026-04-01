

import UIKit
import SnapKit

class ResultVC: BaseGameVC {
    
    // MARK: - UI Elements
    private let popupView = UIView()
    private let titleLabel = UILabel()
    private let fishImageView = UIImageView()
    private let nameLabel = UILabel()
    private lazy var collectButton = createGameButton(title: "COLLECT WIN", color: .systemGreen)
    
    // MARK: - Data
    private var caughtFish: FishModel?
    
    // MARK: - Lifecycle
    init() {
        super.init(showBackButton: false) // На экране победы кнопка "назад" не нужна, только "Collect"
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animateReveal()
    }
    
    // MARK: - Configuration
    func configure(with fish: FishModel) {
        self.caughtFish = fish
        self.fishImageView.image = UIImage(named: fish.imageName)
        self.nameLabel.text = "\(fish.rarity) \(fish.name)".uppercased()
        
        // Меняем цвет текста в зависимости от редкости для красоты
        switch fish.rarity.lowercased() {
        case "common": nameLabel.textColor = .white
        case "rare": nameLabel.textColor = .systemBlue
        case "epic": nameLabel.textColor = .systemPurple
        case "legendary": nameLabel.textColor = .systemOrange
        default: nameLabel.textColor = .white
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Затемняющая подложка (уже есть в BaseGameVC через фон, тут делаем акцент на поп-ап)
        
        // Основная плашка поп-апа
        popupView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 0.95)
        popupView.layer.cornerRadius = 30
        popupView.layer.borderWidth = 4
        popupView.layer.borderColor = UIColor.systemYellow.cgColor
        
        // Начальное состояние для анимации
        popupView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        popupView.alpha = 0
        
        view.addSubview(popupView)
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(450)
        }
        
        // Заголовок
        titleLabel.text = "MEGA CATCH!"
        titleLabel.textColor = .systemYellow
        titleLabel.font = .systemFont(ofSize: 36, weight: .black)
        titleLabel.textAlignment = .center
        
        popupView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        // Изображение трофея
        fishImageView.contentMode = .scaleAspectFit
        popupView.addSubview(fishImageView)
        fishImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(180)
        }
        
        // Название рыбы
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        
        popupView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(fishImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Кнопка забрать
        collectButton.addTarget(self, action: #selector(collectTapped), for: .touchUpInside)
        popupView.addSubview(collectButton)
        collectButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(60)
        }
    }
    
    // MARK: - Animations
    private func animateReveal() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.popupView.transform = .identity
            self.popupView.alpha = 1
        }
    }
    
    // MARK: - Actions
    @objc private func collectTapped() {
        // Просто закрываем текущий экран и возвращаемся в меню (GameVC)
        dismiss(animated: false)
    }
}
