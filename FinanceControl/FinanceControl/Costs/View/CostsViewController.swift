import UIKit
import RxSwift

class CostsViewController: UIViewController {
    
    private var addButton = UIButton()
    private var costsTableView = UITableView()
    
    private let bag = DisposeBag()
    private var viewModel: CostsViewModel!
    var category: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CostsViewModel(categoryKey: category)
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .systemBackground
        
        setupButton()
        setupTable()
        
        bindTable()
        plusTapped()
        
    }
    
    func bindTable() {
        viewModel.objects
            .bind(to: costsTableView.rx.items(cellIdentifier: "CostCell", cellType: CostTableViewCell.self)) { row, element, cell in
                cell.dateLabel.text = element.date.formatDate()
                cell.valueLabel.text = "\(element.value) RUB"
                cell.primaryKey = element.key
                cell.descriptionLabel.text = element.name
            }
            .disposed(by: bag)
    }
    
    func plusTapped() {
        self.addButton.rx.tap.bind { [self] in
            let popover = CostPopover()
            popover.modalPresentationStyle = .popover
            popover.viewModel = viewModel
            let popoverPC = popover.popoverPresentationController
            popoverPC?.delegate = self
            popoverPC?.sourceView = addButton
            self.present(popover, animated: true)
        }
        .disposed(by: bag)
    }
    //MARK: -- Setup UI
    func setupButton() {
        self.view.addSubview(addButton)
        addButton.setImage(.add, for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    func setupTable() {
        self.view.addSubview(costsTableView)
        costsTableView.delegate = self
        costsTableView.register(CostTableViewCell.self, forCellReuseIdentifier: "CostCell")
        costsTableView.rowHeight = 60
        costsTableView.allowsSelection = false
        //TableView constraints:
        costsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            costsTableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            costsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            costsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            costsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
//MARK:-- Extensions
extension CostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! CostTableViewCell
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить",
                                              handler: { [self]  (contextualAction, view, boolValue) in
                                                viewModel.deleteObject(cell.primaryKey)
                                              })
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}

extension CostsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
