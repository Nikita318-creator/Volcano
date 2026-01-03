import UIKit
import SnapKit
import AVFoundation
import AVKit
internal import StoreKit
import WebKit
import MobileCoreServices

class ThirdVC: UIViewController {

    private let imagePicker = UIImagePickerController()
    private var videoPlayer: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    // Список категорий для подсчета общего счета
    private let categoryKeys = [
        "Plate Tectonics", "Mineralogy", "Sedimentary Rocks", "Volcanic Activity",
        "Paleontology", "Soil Science", "Oceanography", "Metamorphic Rocks",
        "Crystal Systems", "Erosion Processes"
    ]

    // MARK: - UI Components
    
    private lazy var avatarContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.borderColor = UIColor.systemOrange.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 50 // Немного уменьшил для симметрии с текстом
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center // Центрируем иконку плюса
        iv.image = UIImage(systemName: "plus.circle.fill") // Иконка плюсика по умолчанию
        iv.preferredSymbolConfiguration = .init(pointSize: 40, weight: .light)
        iv.tintColor = .systemOrange
        return iv
    }()
    
    // Name Input
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.text = "nikname_610" // Дефолтное имя
        tf.textAlignment = .left // Текст слева
        tf.textColor = .label
        tf.font = .systemFont(ofSize: 24, weight: .bold)
        tf.returnKeyType = .done
        tf.delegate = self
        return tf
    }()
    
    // Score Label
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemOrange
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    // Buttons Stack
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    // Footer Stack (теперь пустой или для других нужд, так как кнопки ушли вверх)
    private lazy var footerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
        setupConstraints()
        setupActions()
        loadUserData()
        updateTotalScore() // Считаем общие баллы
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.videoMaximumDuration = 5
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = avatarContainer.bounds
    }

    // MARK: - Setup UI & Background
    
    private func setupBackground() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: Const.backgroundImagename)
        backgroundImageView.backgroundColor = .systemBackground
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    private func setupUI() {
        view.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarImageView)
        
        view.addSubview(nameTextField)
        view.addSubview(scoreLabel)
        view.addSubview(mainStackView)
        view.addSubview(footerStackView)
        
        // 1. Самые первые кнопки (Privacy & Terms)
        mainStackView.addArrangedSubview(createButton(title: "Privacy Policy", action: #selector(openPrivacy)))
        
        // 2. Остальные кнопки
        mainStackView.addArrangedSubview(createButton(title: "Share Progress", action: #selector(shareResult)))
        mainStackView.addArrangedSubview(createButton(title: "Invite Students", action: #selector(inviteFriends)))
        mainStackView.addArrangedSubview(createButton(title: "Rate Us", action: #selector(rateApp)))
    }
    
    private func setupConstraints() {
        // Аватар справа
        avatarContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalToSuperview().inset(30)
            make.width.height.equalTo(100)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Имя слева от аватара
        nameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(avatarContainer.snp.centerY).offset(-15)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalTo(avatarContainer.snp.leading).offset(-20)
        }
        
        // Счет под именем
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(4)
            make.leading.equalTo(nameTextField.snp.leading)
            make.trailing.equalTo(nameTextField.snp.trailing)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(avatarContainer.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        footerStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    private func setupActions() {
        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarContainer.addGestureRecognizer(tapAvatar)
    }

    // MARK: - Score Logic
    
    private func updateTotalScore() {
        var total = 0
        for cat in categoryKeys {
            let key = "Score_\(cat)"
            total += UserDefaults.standard.integer(forKey: key)
        }
        scoreLabel.text = "TOTAL SCORE: \(total)"
    }

    // MARK: - Factory Methods for Buttons
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title.uppercased(), for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        btn.backgroundColor = .secondarySystemBackground
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.systemGray5.cgColor
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.snp.makeConstraints { $0.height.equalTo(55) }
        return btn
    }
    
    private func createFooterButton(title: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.systemGray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }

    // MARK: - Logic: Actions
    
    @objc private func shareResult() {
        let textToShare = "I have collected \(scoreLabel.text ?? "0") points in GeoQuiz! Join me."
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc private func rateApp() {
        if let scene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    @objc private func openPrivacy() {
        present(InpuDataViewController(url: Const.privacyURL, title: "Privacy"), animated: true)
    }
    
    @objc private func inviteFriends() {
        // Кастомный модал вместо actionSheet
        let actions: [CustomModalAction] = [
            CustomModalAction(title: "Telegram", handler: { [weak self] in self?.processInvite(schema: "tg://") }),
            CustomModalAction(title: "WhatsApp", handler: { [weak self] in self?.processInvite(schema: "whatsapp://") }),
            CustomModalAction(title: "Mail", handler: { [weak self] in self?.processInvite(schema: "mailto:?body=") }),
            CustomModalAction(title: "Instagram", handler: { [weak self] in self?.processInvite(schema: "instagram://") }),
            CustomModalAction(title: "Cancel", style: CustomModalActionStyle.cancel, handler: nil)
        ]
        let modal = CustomModalViewController(title: "Invite Friends", message: "Choose a platform", actions: actions)
        present(modal, animated: true)
    }
    
    private func processInvite(schema: String) {
        // Кастомный confirm вместо alert
        let actions: [CustomModalAction] = [
            CustomModalAction(title: "OK", handler: {
                UIPasteboard.general.string = Const.appLink
                if let url = URL(string: schema) {
                    UIApplication.shared.open(url, options: [:])
                }
            }),
            CustomModalAction(title: "Cancel", style: CustomModalActionStyle.cancel, handler: nil)
        ]
        let modal = CustomModalViewController(title: "Copy Link?", message: "Copy the app link to your clipboard?", actions: actions)
        present(modal, animated: true)
    }
    
    // MARK: - Avatar Logic
    
    @objc private func avatarTapped() {
        let actions: [CustomModalAction] = [
            CustomModalAction(title: "Camera", handler: { [weak self] in self?.openCamera() }),
            CustomModalAction(title: "Gallery", handler: { [weak self] in self?.openGallery() }),
            CustomModalAction(title: "Cancel", style: CustomModalActionStyle.cancel, handler: nil)
        ]
        let modal = CustomModalViewController(title: "Update Profile Photo", message: nil, actions: actions)
        present(modal, animated: true)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        present(imagePicker, animated: true)
    }
    
    private func openGallery() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    // MARK: - Data Persistence
    
    private func loadUserData() {
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: Const.keyUserName) {
            nameTextField.text = name
        }
        
        let type = defaults.string(forKey: Const.keyAvatarType)
        let path = defaults.string(forKey: Const.keyAvatarPath)
        
        if type == "video", let path = path {
            playVideoAvatar(url: StorageManager.shared.getVideoURL(name: path))
        } else if let path = path, let image = StorageManager.shared.loadImage(name: path) {
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.image = image
            removeVideoLayer()
        }
    }
    
    private func saveData(type: String, filename: String) {
        UserDefaults.standard.set(type, forKey: Const.keyAvatarType)
        UserDefaults.standard.set(filename, forKey: Const.keyAvatarPath)
    }
}

// MARK: - TextField Delegate
extension ThirdVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.set(textField.text, forKey: Const.keyUserName)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Image Picker & Video Handling
extension ThirdVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let mediaType = info[.mediaType] as? String
        
        if mediaType == "public.image", let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            let filename = "avatar_\(UUID().uuidString).jpg"
            if let savedName = StorageManager.shared.saveImage(image, name: filename) {
                avatarImageView.contentMode = .scaleAspectFill
                avatarImageView.image = image
                removeVideoLayer()
                saveData(type: "image", filename: savedName)
            }
        }
        
        if mediaType == "public.movie", let videoURL = info[.mediaURL] as? URL {
            trimAndSaveVideo(url: videoURL)
        }
    }
    
    private func trimAndSaveVideo(url: URL) {
        let filename = "avatar_video_\(UUID().uuidString).mov"
        if let savedName = StorageManager.shared.saveVideo(at: url, name: filename) {
            let savedURL = StorageManager.shared.getVideoURL(name: savedName)
            playVideoAvatar(url: savedURL)
            saveData(type: "video", filename: savedName)
        }
    }
    
    private func playVideoAvatar(url: URL) {
        removeVideoLayer()
        avatarImageView.isHidden = true
        
        let playerItem = AVPlayerItem(url: url)
        videoPlayer = AVPlayer(playerItem: playerItem)
        videoPlayer?.isMuted = true
        
        playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer?.frame = avatarContainer.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let layer = playerLayer {
            avatarContainer.layer.addSublayer(layer)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: .AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
        videoPlayer?.play()
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.videoPlayer?.seek(to: .zero)
            self?.videoPlayer?.play()
        }
    }
    
    @objc private func loopVideo() {
        videoPlayer?.seek(to: .zero)
        videoPlayer?.play()
    }
    
    private func removeVideoLayer() {
        videoPlayer?.pause()
        videoPlayer = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        avatarImageView.isHidden = false
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

// MARK: - Custom Modal for Alerts

struct CustomModalAction {
    let title: String
    let style: CustomModalActionStyle
    let handler: (() -> Void)?
    
    init(title: String, style: CustomModalActionStyle = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

enum CustomModalActionStyle {
    case `default`, cancel, destructive
}

class CustomModalViewController: UIViewController {
    
    private let modalTitle: String?
    private let modalMessage: String?
    private let actions: [CustomModalAction]
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = modalTitle
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = modalMessage
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private var emitterLayer: CAEmitterLayer?
    
    init(title: String?, message: String?, actions: [CustomModalAction]) {
        self.modalTitle = title
        self.modalMessage = message
        self.actions = actions
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupUI()
        setupParticles()
        animateEntry()
    }
    
    private func setupUI() {
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(stackView)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.greaterThanOrEqualTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        for action in actions {
            let button = createModalButton(for: action)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createModalButton(for action: CustomModalAction) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(action.title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemOrange.cgColor
        
        switch action.style {
        case .default:
            btn.setTitleColor(.systemOrange, for: .normal)
            btn.backgroundColor = .secondarySystemBackground
        case .cancel:
            btn.setTitleColor(.systemGray, for: .normal)
            btn.backgroundColor = .systemBackground
        case .destructive:
            btn.setTitleColor(.systemRed, for: .normal)
            btn.backgroundColor = .secondarySystemBackground
        }
        
        btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        btn.tag = actions.firstIndex(where: { $0.title == action.title }) ?? 0
        return btn
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let action = actions[sender.tag]
        dismiss(animated: true) {
            action.handler?()
        }
    }
    
    // MARK: - Animations & Particles
    
    private func animateEntry() {
        contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        contentView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.contentView.transform = .identity
            self.contentView.alpha = 1
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 0
            self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { _ in
            super.dismiss(animated: false, completion: completion)
            self.emitterLayer?.removeFromSuperlayer()
        }
    }
    
    private func setupParticles() {
        emitterLayer = CAEmitterLayer()
        emitterLayer?.emitterPosition = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.minY - 50)
        emitterLayer?.emitterSize = CGSize(width: contentView.bounds.width, height: 1)
        emitterLayer?.emitterShape = .line
        
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 3.0
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionRange = .pi
        cell.scale = 0.05
        cell.scaleRange = 0.02
        cell.color = UIColor.systemOrange.cgColor
        cell.contents = UIImage(systemName: "flame.fill")?.cgImage
        
        emitterLayer?.emitterCells = [cell]
        contentView.layer.addSublayer(emitterLayer!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == view {
            dismiss(animated: true)
        }
    }
}


// MARK: - 1. Constants & Configuration
enum Const {
    static let backgroundImagename = "purple_bg"
    static let appLink = "https://apps.apple.com/app/id6757113019"
    
    // Placeholder URLs
    static let privacyURL = "https://sites.google.com/view/geoquiz65"
    
    // Keys
    static let keyUserName = "UserProfileName"
    static let keyAvatarType = "UserAvatarType"
    static let keyAvatarPath = "UserAvatarPath"
}

class StorageManager {
    static let shared = StorageManager()
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveImage(_ image: UIImage, name: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        try? data.write(to: filename)
        return name
    }
    
    func saveVideo(at url: URL, name: String) -> String? {
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        try? FileManager.default.removeItem(at: filename)
        try? FileManager.default.copyItem(at: url, to: filename)
        return name
    }
    
    func loadImage(name: String) -> UIImage? {
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile: filename.path)
    }
    
    func getVideoURL(name: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(name)
    }
}

class InpuDataViewController: UIViewController {
    private let urlString: String
    private let outputView = WKWebView()
    
    init(url: String, title: String) {
        self.urlString = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(outputView)
        outputView.snp.makeConstraints { $0.edges.equalToSuperview() }
        if let url = URL(string: urlString) {
            outputView.load(URLRequest(url: url))
        }
    }
}
