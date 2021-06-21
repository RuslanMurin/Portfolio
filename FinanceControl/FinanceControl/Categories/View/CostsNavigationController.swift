import UIKit

class CostsNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [CategoriesViewController()]
    }
}
