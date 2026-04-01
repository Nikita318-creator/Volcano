import UIKit
import SnapKit

class CollectionVC: UIViewController {
    
    private var collectionView: UICollectionView!
    
    // Custom Navigation Bar
    private let headerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TROPHY ROOM"
        label.font = .systemFont(ofSize: 22, weight: .black)
        label.textColor = .white
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1.0)
        setupHeader()
        setupCollectionView()
    }
    
    private func setupHeader() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        headerView.addSubview(backButton)
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (UIScreen.main.bounds.width - 60) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FishCollectionCell.self, forCellWithReuseIdentifier: "FishCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc private func close() {
        dismiss(animated: false)
    }
}

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FishManager.shared.allFish.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FishCell", for: indexPath) as! FishCollectionCell
        cell.configure(with: FishManager.shared.allFish[indexPath.item])
        return cell
    }
}

// MARK: - Исправленная Ячейка
class FishCollectionCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    // Блюр теперь накрывает только картинку
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.05)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(white: 1, alpha: 0.1).cgColor
        
        contentView.addSubview(imageView)
        
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        // Настраиваем блюр: он должен быть внутри imageView или поверх неё строго по границам
        imageView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        blurEffectView.layer.cornerRadius = 12
        blurEffectView.clipsToBounds = true
        
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 14, weight: .bold)
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    func configure(with fish: FishModel) {
        imageView.image = UIImage(named: fish.imageName)
        
        if fish.isCaught {
            blurEffectView.isHidden = true
            imageView.alpha = 1.0
            nameLabel.text = fish.name.uppercased()
            nameLabel.textColor = .systemYellow
        } else {
            // Легкий блюр, через который видно силуэт
            blurEffectView.isHidden = false
            blurEffectView.alpha = 0.9
            imageView.alpha = 0.6
            nameLabel.text = "UNKNOWN"
            nameLabel.textColor = .lightGray
        }
    }
}
