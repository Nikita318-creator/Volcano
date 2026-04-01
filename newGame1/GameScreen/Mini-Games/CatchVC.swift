import UIKit
import SnapKit

class CatchVC: BaseGameVC {
    
    private var collectionView: UICollectionView!
    private var cards: [Int] = []
    private var flippedIndices: [IndexPath] = []
    private var matchedPairs = 0
    private let totalPairs = 6
    
    // ДЕТАЛЬНЫЕ ПРАВИЛА
    private let rulesLabel: UILabel = {
        let label = UILabel()
        label.text = "\nHOW TO PLAY:\n1. TAP A CARD TO FLIP IT\n2. FIND TWO IDENTICAL SYMBOLS\n3. CLEAR THE BOARD TO WIN\n"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .black)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .black.withAlphaComponent(0.7)

        // Тень для читаемости
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    var onGameFinished: (() -> Void)?
    
    init() {
        super.init(showBackButton: true)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.image = UIImage(named: "bg_story")
        setupCards()
        setupUI()
    }
    
    private func setupCards() {
        let pairs = (1...totalPairs).flatMap { [$0, $0] }
        cards = pairs.shuffled()
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 80) / 3
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(itemWidth * 1.2 * 4 + 60)
        }
        
        // РАЗМЕЩЕНИЕ ПРАВИЛ ПОД КОЛЛЕКЦИЕЙ
        view.addSubview(rulesLabel)
        rulesLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }
    }
    
    private func checkMatch() {
        guard flippedIndices.count == 2 else { return }
        
        let firstIdx = flippedIndices[0]
        let secondIdx = flippedIndices[1]
        
        if cards[firstIdx.item] == cards[secondIdx.item] {
            matchedPairs += 1
            
            let cell1 = collectionView.cellForItem(at: firstIdx)
            let cell2 = collectionView.cellForItem(at: secondIdx)
            
            UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseIn) {
                cell1?.alpha = 0
                cell2?.alpha = 0
            } completion: { _ in
                self.flippedIndices.removeAll()
                if self.matchedPairs == self.totalPairs {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.onGameFinished?()
                    }
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                for indexPath in self.flippedIndices {
                    if let cell = self.collectionView.cellForItem(at: indexPath) as? CardCell {
                        cell.flipDown()
                    }
                }
                self.flippedIndices.removeAll()
            }
        }
    }
}

// MARK: - CollectionView Methods
extension CatchVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.configure(with: cards[indexPath.item])
        cell.alpha = 1.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell,
              cell.alpha > 0,
              !flippedIndices.contains(indexPath),
              flippedIndices.count < 2 else { return }
        
        cell.flipUp()
        flippedIndices.append(indexPath)
        
        if flippedIndices.count == 2 {
            checkMatch()
        }
    }
}

// MARK: - CardCell
class CardCell: UICollectionViewCell {
    private let frontView = UIImageView()
    private let backView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        backView.image = UIImage(named: "card_back")
        backView.contentMode = .scaleAspectFill
        
        frontView.contentMode = .scaleAspectFit
        frontView.backgroundColor = .white
        frontView.isHidden = true
        
        contentView.addSubview(frontView)
        contentView.addSubview(backView)
        
        frontView.snp.makeConstraints { $0.edges.equalToSuperview().inset(5) }
        backView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    func configure(with id: Int) {
        frontView.image = UIImage(named: "symbol_\(id)")
        backView.isHidden = false
        frontView.isHidden = true
    }
    
    func flipUp() {
        UIView.transition(from: backView, to: frontView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews])
    }
    
    func flipDown() {
        UIView.transition(from: frontView, to: backView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews])
    }
}
