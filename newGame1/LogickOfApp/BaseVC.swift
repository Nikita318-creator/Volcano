import UIKit
import SnapKit

class BaseVC: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .red
    }
    
}
