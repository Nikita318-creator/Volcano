import UIKit
import SnapKit

// Расширенная модель для контента
struct DetailedContent {
    let mainTitle: String
    let sections: [ContentSection]
}

struct ContentSection {
    let subTitle: String
    let text: String
}

class CategoryDetailViewController: UIViewController {
    
    var categoryData: GeoCategory?
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let blurOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) // Затемнение для читаемости
        return view
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        btn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let circleIconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.systemOrange.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circleIconView.layer.cornerRadius = circleIconView.frame.width / 2
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // 1. Background Image
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 2. Blur/Dark Overlay
        view.addSubview(blurOverlay)
        blurOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 3. Scroll View
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // 4. Circle Icon (На всю ширину почти)
        contentView.addSubview(circleIconView)
        circleIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(circleIconView.snp.width)
        }
        
        // 5. Stack View for Text content
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(circleIconView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        // 6. Back Button
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    private func loadData() {
        guard let data = categoryData else { return }
        
        backgroundImageView.image = UIImage(named: data.imageName)
        circleIconView.image = UIImage(named: data.imageName)
        
        // Mock контент (можно вынести в отдельный сервис)
        let mockDetailedContent = DetailedContent(
            mainTitle: data.title.uppercased(),
            sections: [
                ContentSection(subTitle: "1. Overview", text: "Geological processes are the driving force behind the formation of our planet's landscape. These processes occur over millions of years, shaping mountains, valleys, and oceanic basins through tectonic movements and volcanic eruptions. Understanding these dynamics is essential for any earth science student."),
                ContentSection(subTitle: "2. Historical Context", text: "Since the early stages of Earth's formation, thermal convection in the mantle has played a pivotal role. Magma rises to the surface, creating new crust at mid-ocean ridges, while old crust is recycled back into the mantle at subduction zones. This constant recycling is what we call the Rock Cycle."),
                ContentSection(subTitle: "3. Scientific Importance", text: "The study of these formations provides clues about the Earth's past climate and the evolution of life. By analyzing strata and mineral compositions, scientists can reconstruct environments from billions of years ago. This helps in predicting future geological shifts."),
                ContentSection(subTitle: "4. Key Terminology", text: "It is crucial to distinguish between various geological phenomena. For instance, the difference between intrusive and extrusive igneous rocks depends on where the magma solidifies. Intrusive rocks cool slowly beneath the surface, forming large crystals, whereas extrusive rocks cool rapidly on the surface."),
                ContentSection(subTitle: "5. Global Impact", text: "Geological activity affects human civilization through natural resources and natural hazards. From the mining of precious minerals to the monitoring of seismic zones, geology is at the forefront of safety and economic development in the modern world.")
            ]
        )
        
        renderContent(mockDetailedContent)
    }
    
    private func renderContent(_ content: DetailedContent) {
        // Main Title
        let mainLabel = UILabel()
        mainLabel.text = content.mainTitle
        mainLabel.textColor = .systemOrange
        mainLabel.font = .systemFont(ofSize: 32, weight: .black)
        mainLabel.numberOfLines = 0
        mainLabel.textAlignment = .center
        stackView.addArrangedSubview(mainLabel)
        
        // Sections
        for section in content.sections {
            let subLabel = UILabel()
            subLabel.text = section.subTitle
            subLabel.textColor = .white
            subLabel.font = .systemFont(ofSize: 22, weight: .bold)
            
            let textLabel = UILabel()
            textLabel.text = section.text
            textLabel.textColor = .lightGray
            textLabel.font = .systemFont(ofSize: 16, weight: .regular)
            textLabel.numberOfLines = 0
            
            stackView.addArrangedSubview(subLabel)
            stackView.addArrangedSubview(textLabel)
            
            // Маленький отступ между секциями
            stackView.setCustomSpacing(10, after: subLabel)
        }
    }
    
    @objc private func backAction() {
        dismiss(animated: true)
    }
}
