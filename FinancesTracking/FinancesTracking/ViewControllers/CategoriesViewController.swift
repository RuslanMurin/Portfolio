import UIKit

class CategoriesViewController: UIViewController {
    @IBOutlet weak var categoriesTableView: UITableView!
    
    let costViewModel = CostViewModel.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        //--------------------Setup Popover--------------------
        setupPopover(pop: GroupPopoverVC(), parent: self, identifier: "CategoryPopover", sender: sender, storyboard: storyboard)
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        costViewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CostCategoryCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryNameLabel.text = costViewModel.categories[indexPath.row].groupName
        return cell
    }
    //--------------------Delete Row--------------------
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let category = self.costViewModel.categories[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Удалить",
                                              handler: { [self]  (contextualAction, view, boolValue) in
                                                costViewModel.deleteCategory(category.key)
                                                tableView.deleteRows(at: [indexPath], with: .fade)})
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    //--------------------Create Category's VC--------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "CostsViewController") as? CostsViewController {
            viewController.category = costViewModel.categories[indexPath.row]
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CategoriesViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
//--------------------Pass Data from Popover--------------------
extension CategoriesViewController: UpdateDataDelegate{
    func okButtonPressed() {
        categoriesTableView.reloadData()
    }
}
