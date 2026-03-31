
import UIKit
import SnapKit

class CatchVC: UIViewController {
    
    private var collectionView: UICollectionView!
    private var cards: [Int] = [] // ID пар
    private var flippedIndices: [IndexPath] = []
    private var matchedPairs = 0
    private let totalPairs = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.05, green: 0.1, blue: 0.2, alpha: 1.0)
        setupCards()
        setupUI()
    }
    
    private func setupCards() {
        let pairs = (1...totalPairs).flatMap { [$0, $0] }
        cards = pairs.shuffled()
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (UIScreen.main.bounds.width - 80) / 3
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
    }
    
    private func checkMatch() {
        guard flippedIndices.count == 2 else { return }
        
        let first = flippedIndices[0]
        let second = flippedIndices[1]
        
        if cards[first.item] == cards[second.item] {
            // Match
            matchedPairs += 1
            flippedIndices.removeAll()
            
            if matchedPairs == totalPairs {
                // Win
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let resultVC = ResultVC()
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
        } else {
            // No match, flip back
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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

extension CatchVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.configure(with: cards[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard flippedIndices.count < 2, !flippedIndices.contains(indexPath) else { return }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CardCell, !cell.isFlipped {
            cell.flipUp()
            flippedIndices.append(indexPath)
            if flippedIndices.count == 2 {
                checkMatch()
            }
        }
    }
}

// Кастомная ячейка для анимации переворота
class CardCell: UICollectionViewCell {
    private let frontView = UIImageView()
    private let backView = UIImageView(image: UIImage(named: "card_back")) // Ассет рубашки
    var isFlipped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setup() {
        contentView.addSubview(frontView)
        contentView.addSubview(backView)
        frontView.snp.makeConstraints { $0.edges.equalToSuperview() }
        backView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        frontView.backgroundColor = .white
        frontView.isHidden = true
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    func configure(with id: Int) {
        // Условно: id = номер картинки символа
        frontView.image = UIImage(named: "symbol_\(id)")
    }
    
    func flipUp() {
        isFlipped = true
        UIView.transition(from: backView, to: frontView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews])
    }
    
    func flipDown() {
        isFlipped = false
        UIView.transition(from: frontView, to: backView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews])
    }
}
