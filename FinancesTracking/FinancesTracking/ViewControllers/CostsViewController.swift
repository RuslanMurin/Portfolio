import UIKit

class CostsViewController: UIViewController{
    @IBOutlet weak var costsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let costsSingleton = CostInfrastructure.shared
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        titleLabel.text = category?.groupName ?? ""
    }
    
    @IBAction func plusPressed(_ sender: UIButton) {
        //--------------------Setup Popover--------------------
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "CostPopover") as? CostPopoverVC else { return }
        popVC.modalPresentationStyle = .popover
        popVC.delegate = self
        popVC.categoryKey = self.category?.key ?? ""
        popVC.preferredContentSize = CGSize(width: self.view.bounds.width, height: 150)
        let popoverVC = popVC.popoverPresentationController
        popoverVC?.delegate = self
        popoverVC?.sourceView = sender
        popoverVC?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.maxY, width: 0, height: 0)
        self.present(popVC, animated: true)
    }
    //--------------------Create Chart VC--------------------
    @IBAction func showChartPressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(identifier: "CostsChart") as? CostsChartViewController else { return }
        vc.category = self.category
        self.present(vc, animated: true)
    }
}

extension CostsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        costsSingleton.findCostsByKey(key: category?.key ?? "").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CostCell", for: indexPath) as! CostTableViewCell
        let costs = costsSingleton.findCostsByKey(key: category?.key ?? "")
        cell.nameLabel.text = costs[indexPath.row].name
        cell.dateLabel.text = costs[indexPath.row].date.formatDate()
        cell.valueLabel.text = "\(costs[indexPath.row].value) Р"
        return cell
    }
    //--------------------Delete Row--------------------
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cost = self.costsSingleton.findCostsByKey(key: category?.key ?? "")[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Удалить",
                                              handler: { [self]  (contextualAction, view, boolValue) in
                                                costsSingleton.deleteCost(cost.key)
                                                tableView.deleteRows(at: [indexPath], with: .fade)})
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}

extension CostsViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
//--------------------Pass Data From Popover--------------------
extension CostsViewController: UpdateDataDelegate{
    func okButtonPressed() {
        costsTableView.reloadData()
    }
}
