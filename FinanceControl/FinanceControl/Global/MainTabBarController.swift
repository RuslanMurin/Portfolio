import UIKit

class MainTabBarController: UITabBarController {
    
    let firstVC = IncomesViewController()
    let secondVC = ChartViewController()
    let thirdVC = CostsNavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstVC.title = "Incomes"
        secondVC.title = "Chart"
        thirdVC.title = "Costs"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let controllers: [UIViewController] = [firstVC, secondVC, thirdVC]
        self.viewControllers = controllers
    }

}
