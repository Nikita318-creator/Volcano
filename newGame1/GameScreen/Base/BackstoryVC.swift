

import UIKit
import SnapKit

class BackstoryVC: UIViewController {
    
    private let containerView = UIView()
    private let scrollView = UIScrollView()
    private let textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        
        containerView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor = UIColor.systemPurple.cgColor
        containerView.layer.borderWidth = 2
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("CLOSE", for: .normal)
        closeBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .black)
        closeBtn.setTitleColor(.systemYellow, for: .normal)
        closeBtn.addTarget(self, action: #selector(dismissBack), for: .touchUpInside)
        
        containerView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        containerView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(closeBtn.snp.top).offset(-10)
        }
        
        textLabel.numberOfLines = 0
        textLabel.attributedText = createBackstoryText()
        scrollView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    @objc private func dismissBack() { dismiss(animated: true) }
    
    private func createBackstoryText() -> NSAttributedString {
        let fullString = NSMutableAttributedString()
        
        let titleStyle: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 26, weight: .black),
            .foregroundColor: UIColor.systemYellow
        ]
        
        let subTitleStyle: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: 18),
            .foregroundColor: UIColor.lightGray
        ]
        
        let bodyStyle: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.white
        ]
        
        let boldStyle: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.systemCyan
        ]

        fullString.append(NSAttributedString(string: "THE LEGEND OF MIKE\n", attributes: titleStyle))
        fullString.append(NSAttributedString(string: "A fisherman's destiny frozen in time\n\n", attributes: subTitleStyle))
        
        fullString.append(NSAttributedString(string: "Mike wasn't always a cold-blooded ice driller. Years ago, he was a simple sailor, chasing the sun in the southern seas. But everything changed during the ", attributes: bodyStyle))
        fullString.append(NSAttributedString(string: "Great Frost of 2018. ", attributes: boldStyle))
        
        fullString.append(NSAttributedString(string: "His grandfather, an old arctic explorer, left him a strange, flickering sonar. Some say it doesn't track fish—it tracks memories of the ancient world hidden beneath the miles of permafrost.\n\n", attributes: bodyStyle))
        
        fullString.append(NSAttributedString(string: "THE CURSE OF BLUE BAY\n", attributes: [
            .font: UIFont.systemFont(ofSize: 20, weight: .black),
            .foregroundColor: UIColor.systemCyan
        ]))
        
        fullString.append(NSAttributedString(string: "\nWhy is he here? Mike believes that the legendary King Fish swallowed his family's lucky compass decades ago. To get it back, he must navigate through 20 deadly sectors, each thicker and more dangerous than the last. The ice isn't just water—it's a barrier of time. Swapping these symbols and drilling the holes is the only way to sync the ancient sonar and find the exact coordinates of the abyss.\n\n", attributes: bodyStyle))
        
        fullString.append(NSAttributedString(string: "Every match you make, every trophy you find, brings Mike closer to the truth. Is it just fish? Or is there something... bigger... waiting in the dark silence of the deep?", attributes: bodyStyle))
        
        return fullString
    }
}
