import UIKit
import SnapKit

class ExamCell: UITableViewCell {
    let imgView = UIImageView()
    let titleLabel = UILabel()
    let scoreLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imgView.frame = CGRect(x: 15, y: 10, width: 60, height: 60)
        imgView.layer.cornerRadius = 8
        imgView.backgroundColor = .systemGray5
        
        titleLabel.frame = CGRect(x: 85, y: 20, width: 180, height: 40)
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        scoreLabel.frame = CGRect(x: frame.width - 20, y: 20, width: 70, height: 40)
        scoreLabel.textColor = .systemOrange
        scoreLabel.textAlignment = .right
        
        contentView.addSubview(imgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scoreLabel)
    }
    required init?(coder: NSCoder) { fatalError() }
}
