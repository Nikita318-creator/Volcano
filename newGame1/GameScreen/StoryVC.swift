import UIKit
import SnapKit

class StoryVC: BaseGameVC {
    var onFinished: (() -> Void)?
    
    private let characterImageView = UIImageView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let storyLabel = UILabel()
    private lazy var nextButton = createGameButton(title: "NEXT", color: .systemBlue)
    
    private var storyLines: [String] = []
    private var currentLineIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.image = UIImage(named: "bg_story")
        storyLines = StoryEngine.getStory(for: GameManager.shared.currentLevel)
        setupUI()
        updateStoryContent()
    }
    
    private func setupUI() {
        view.addSubview(characterImageView)
        characterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(characterImageView.snp.width)
        }
        
        blurView.layer.cornerRadius = 30
        blurView.clipsToBounds = true
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(220)
        }
        
        storyLabel.textColor = .white
        storyLabel.font = .systemFont(ofSize: 20, weight: .black)
        storyLabel.numberOfLines = 0
        storyLabel.textAlignment = .center
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
        storyLabel.text = storyLines[currentLineIndex]
        
        // Рыбалка, а не дриллинг: адаптируем текст под контекст
        if currentLineIndex == storyLines.count - 1 {
            nextButton.setTitle("LET'S GO!", for: .normal)
        }
    }
    
    @objc private func nextTapped() {
        if currentLineIndex < storyLines.count - 1 {
            currentLineIndex += 1
            updateStoryContent()
        } else {
            // Уходим через кложуру, не презентим ничего сами!
            onFinished?()
        }
    }
}
