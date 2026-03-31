

import UIKit
import SnapKit

class ResultVC: BaseGameVC {
    
    private let popupView = UIView()
    private let titleLabel = UILabel()
    private let fishImageView = UIImageView()
    private let nameLabel = UILabel()
    private lazy var collectButton = createGameButton(title: "COLLECT WIN", color: .systemGreen)
    
    private var caughtFish: FishModel!
    
    init() {
        super.init(showBackButton: false) // На экране победы нельзя просто уйти назад
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caughtFish = FishManager.shared.catchRandomFish()
        GameManager.shared.levelUp()
        setupUI()
        animateReveal()
    }
    
    private func setupUI() {
        // Плашка "Big Win"
        popupView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 0.95)
        popupView.layer.cornerRadius = 30
        popupView.layer.borderWidth = 4
        popupView.layer.borderColor = UIColor.systemYellow.cgColor
        popupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        popupView.alpha = 0
        
        view.addSubview(popupView)
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(450)
        }
        
        titleLabel.text = "MEGA CATCH!"
        titleLabel.textColor = .systemYellow
        titleLabel.font = .systemFont(ofSize: 36, weight: .black)
        titleLabel.textAlignment = .center
        
        popupView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        // Тут будет лежать картинка твоей рыбы (слот-символ)
        fishImageView.image = UIImage(named: caughtFish.imageName)
        fishImageView.contentMode = .scaleAspectFit
        
        popupView.addSubview(fishImageView)
        fishImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(180)
        }
        
        nameLabel.text = "\(caughtFish.rarity) \(caughtFish.name)".uppercased()
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textAlignment = .center
        
        popupView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(fishImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        collectButton.addTarget(self, action: #selector(collectTapped), for: .touchUpInside)
        popupView.addSubview(collectButton)
        collectButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(60)
        }
    }
    
    private func animateReveal() {
        // Анимация в стиле выпадения джекпота
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.popupView.transform = .identity
            self.popupView.alpha = 1
        }
    }
    
    @objc private func collectTapped() {
        // Схлопываем ВЕСЬ стек презентованных контроллеров и возвращаемся в GameVC (Root)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
