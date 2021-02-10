import UIKit

class IncomeViewController: UIViewController{
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var incomesTableView: UITableView!
    
    var incomeSingleton = IncomeInfrastructure.shared
    
    func updateBalance(){
        let balance = incomeSingleton.sum - CostInfrastructure.shared.sum
        balanceLabel.text = "\(balance) Р"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBalance()
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        //--------------------Setup Popover--------------------
        setupPopover(pop: IncomePopoverVC(), parent: self, identifier: "IncomePopover", sender: sender, storyboard: storyboard)
    }
}

extension IncomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeSingleton.incomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeCell", for: indexPath) as! IncomeTableViewCell
        cell.valueLabel.text = "\(incomeSingleton.incomes[indexPath.row].value) Р"
        cell.dateLabel.text = incomeSingleton.incomes[indexPath.row].date.formatDate()
        return cell
    }
    //--------------------Delete Row--------------------
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let income = self.incomeSingleton.incomes[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Удалить",
                                              handler: { [self]  (contextualAction, view, boolValue) in
                                                incomeSingleton.deleteIncome(income.key)
                                                updateBalance()
                                                tableView.deleteRows(at: [indexPath], with: .fade)})
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}

extension IncomeViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
//--------------------Pass Data From Popover--------------------
extension IncomeViewController: UpdateDataDelegate{
    func okButtonPressed() {
        updateBalance()
        incomesTableView.reloadData()
    }
}