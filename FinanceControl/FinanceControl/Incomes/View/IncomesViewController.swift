import UIKit
import RxSwift
import RxCocoa
import RxRealm

class IncomesViewController: UIViewController {
    
    private var balanceLabel = UILabel()
    private var titleLabel = UILabel()
    private var addButton = UIButton()
    private var incomesTableView = UITableView()
    
    private let bag = DisposeBag()
    private let viewModel = IncomesViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        
        setupBalanceLabel()
        setupTiltleLabel()
        setupButton()
        setupTable()
        
        bindTable()
        plusTapped()
    }
    //MARK:-- Bindings
    func bindTable() {
        viewModel.objects
            .bind(to: incomesTableView.rx.items(cellIdentifier: "IncomeCell", cellType: IncomeTableViewCell.self)) { row, element, cell in
                cell.dateLabel.text = element.date.formatDate()
                cell.valueLabel.text = "\(element.value) RUB"
                cell.primaryKey = element.key
            }
            .disposed(by: bag)
    }
    
    func plusTapped() {
        self.addButton.rx.tap.bind { [self] in
            let popover = ActionPopover()
            popover.valueTextField.keyboardType = .numbersAndPunctuation
            popover.modalPresentationStyle = .popover
            popover.viewModel = viewModel
            popover.valueTextField.placeholder = "Сумма дохода"
            let popoverPC = popover.popoverPresentationController
            popoverPC?.delegate = self
            popoverPC?.sourceView = addButton
            self.present(popover, animated: true)
        }
        .disposed(by: bag)
    }
    //MARK: --Setup UI
    func setupBalanceLabel() {
        self.view.addSubview(balanceLabel)
        balanceLabel.textAlignment = .right
        balanceLabel.textColor = .green
        
        viewModel.sum.map { "\($0) RUB" }
            .bind(to: balanceLabel.rx.text)
            .disposed(by: bag)
        
        //Label constraints:
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            balanceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            balanceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    func setupTiltleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.text = "Доходы"
        //Label constraints:
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func setupButton() {
        self.view.addSubview(addButton)
        addButton.setImage(.add, for: .normal)
        //Button onstraints:
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
    
    func setupTable() {
        self.view.addSubview(incomesTableView)
        incomesTableView.delegate = self
        incomesTableView.register(IncomeTableViewCell.self, forCellReuseIdentifier: "IncomeCell")
        incomesTableView.rowHeight = 60
        incomesTableView.allowsSelection = false
        //TableView constraints:
        incomesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            incomesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            incomesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            incomesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}
//MARK:-- Extensions
extension IncomesViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension IncomesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! IncomeTableViewCell
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить",
                                              handler: { [self]  (contextualAction, view, boolValue) in
                                                viewModel.deleteObject(cell.primaryKey)
                                              })
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}


