import UIKit
import SnapKit

class StoryVC: BaseGameVC {
    
    // Центральный объект (например, персонаж или снаряжение)
    private let characterImageView = UIImageView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let storyLabel = UILabel()
    private lazy var nextButton = createGameButton(title: "NEXT", color: .systemBlue)
    
    private var storyLines: [String] = []
    private var currentLineIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // КРИТИЧНО: Меняем фон базового контроллера на специфичный для стори
        self.bgImageView.image = UIImage(named: "bg_story")
        
        storyLines = StoryEngine.getStory(for: GameManager.shared.currentLevel)
        setupUI()
        updateStoryContent()
    }
    
    private func setupUI() {
        // Настройка центрального арта
        characterImageView.contentMode = .scaleAspectFit
        view.addSubview(characterImageView)
        characterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(characterImageView.snp.width)
        }
        
        // Настройка плашки диалога
        blurView.layer.cornerRadius = 30
        blurView.clipsToBounds = true
        blurView.layer.borderWidth = 2
        blurView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(220)
        }
        
        storyLabel.textColor = .white
        storyLabel.font = .systemFont(ofSize: 22, weight: .black) // Жирный игровой шрифт
        storyLabel.numberOfLines = 0
        storyLabel.textAlignment = .center
        storyLabel.dropShadow() // Кастомный экстеншн для стиля
        
        blurView.contentView.addSubview(storyLabel)
        storyLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(25)
        }
        
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        blurView.contentView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
    }
    
    private func updateStoryContent() {
        guard currentLineIndex < storyLines.count else { return }
        
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .fade
        
        self.storyLabel.layer.add(transition, forKey: nil)
        self.characterImageView.layer.add(transition, forKey: nil)
        
        self.storyLabel.text = self.storyLines[self.currentLineIndex]
        
        // Меняем персонажа/арт под текущий шаг (ассеты: char_1_0, char_1_1 и т.д.)
        let charImageName = "char_\(GameManager.shared.currentLevel)_\(currentLineIndex)"
        self.characterImageView.image = UIImage(named: charImageName) ?? UIImage(named: "char_default")
        
        if currentLineIndex == storyLines.count - 1 {
            nextButton.setTitle("START DRILLING", for: .normal)
            nextButton.backgroundColor = .systemRed
            nextButton.addPulseAnimation() // Пульсация на финальном шаге
        }
    }
    
    @objc private func nextTapped() {
        if currentLineIndex < storyLines.count - 1 {
            currentLineIndex += 1
            updateStoryContent()
        } else {
            let drillVC = IceDrillVC()
            present(drillVC, animated: true)
        }
    }
}

// MARK: - Хелперы для красоты (вынеси в отдельный файл)
extension UIView {
    func dropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
    }
    
    func addPulseAnimation() {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 1.0
        pulse.toValue = 1.08
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        self.layer.add(pulse, forKey: "pulse")
    }
}
