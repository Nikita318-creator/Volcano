import UIKit
import SnapKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        tabBar.tintColor = .systemOrange
    }
    
    private func setupTabs() {
        let mainVC = GuideViewController()
        let nav1 = UINavigationController(rootViewController: mainVC)
        nav1.tabBarItem = UITabBarItem(title: "Guide", image: UIImage(systemName: "book.fill"), tag: 0)
        
        let quizVC = ExamsViewController()
        let nav2 = UINavigationController(rootViewController: quizVC)
        nav2.tabBarItem = UITabBarItem(title: "Exams", image: UIImage(systemName: "checkmark.seal.fill"), tag: 1)
        
        let thirdVC = ThirdVC()
        thirdVC.view.backgroundColor = .systemBackground
        let nav3 = UINavigationController(rootViewController: thirdVC)
        nav3.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        
        let miniGameScreenVC = MiniGameScreenVC()
        let nav4 = UINavigationController(rootViewController: miniGameScreenVC)
        nav4.tabBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller.fill"), tag: 3)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
}
