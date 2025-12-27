import UIKit
import SnapKit

class GuideCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.numberOfLines = 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        // Layout (упрощенно)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 40)
        titleLabel.frame = CGRect(x: 5, y: frame.height - 40, width: frame.width - 10, height: 40)
    }
    required init?(coder: NSCoder) { fatalError() }
}
