import UIKit
import SnapKit

class CollectionVC: UIViewController {
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0)
        title = "Trophy Room"
        navigationController?.setNavigationBarHidden(false, animated: true) // Показываем бар для кнопки Back
        setupUI()
    }
    
    private func setupUI() {
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
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FishManager.shared.allFish.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FishCell", for: indexPath) as! FishCollectionCell
        let fish = FishManager.shared.allFish[indexPath.item]
        cell.configure(with: fish)
        return cell
    }
}

// Ячейка коллекции
class FishCollectionCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 12
        
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 14, weight: .bold)
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(with fish: FishModel) {
        if fish.isCaught {
            imageView.image = UIImage(named: fish.imageName)
            imageView.alpha = 1.0
            nameLabel.text = fish.name
        } else {
            imageView.image = UIImage(named: fish.imageName)?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .black
            imageView.alpha = 0.3
            nameLabel.text = "???"
        }
    }
}
