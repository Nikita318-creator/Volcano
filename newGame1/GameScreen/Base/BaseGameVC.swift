import UIKit
import SnapKit

class BaseGameVC: UIViewController {
    
    let bgImageView = UIImageView()
    let backButton = UIButton(type: .system)
    var showBackButton: Bool = true
    
    var onDismissed: (() -> Void)?

    init(showBackButton: Bool = true) {
        self.showBackButton = showBackButton
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI()
    }
    
    private func setupBaseUI() {
        // Дефолтный фон для всех экранов (заменишь на игровой ассет)
        bgImageView.image = UIImage(named: "bg_main_snow")
        bgImageView.contentMode = .scaleAspectFill
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        if showBackButton {
            backButton.setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
            backButton.tintColor = .white
            backButton.imageView?.contentMode = .scaleAspectFill
            backButton.contentVerticalAlignment = .fill
            backButton.contentHorizontalAlignment = .fill
            // Добавляем тень для читаемости на любом фоне
            backButton.layer.shadowColor = UIColor.black.cgColor
            backButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            backButton.layer.shadowOpacity = 0.8
            backButton.layer.shadowRadius = 4
            
            backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
            
            view.addSubview(backButton)
            backButton.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
                make.leading.equalToSuperview().offset(20)
                make.width.height.equalTo(44)
            }
        }
    }
    
    @objc func backTapped() {
        onDismissed?()
        // Если мы в игре или истории — просто закрываем текущий экран и возвращаемся в меню
        if let presenting = self.presentingViewController {
            presenting.dismiss(animated: false)
        } else {
            self.dismiss(animated: false)
        }
    }
    
    // Хелпер для создания "игровых" кнопок (стиль слотов/казуалок)
    func createGameButton(title: String, color: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 22, weight: .black)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 3
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        
        // Тень для объема
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 6)
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowRadius = 8
        return btn
    }
}
