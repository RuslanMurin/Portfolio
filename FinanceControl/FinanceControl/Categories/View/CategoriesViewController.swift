import UIKit
import RxCocoa
import RxSwift

class CategoriesViewController: UIViewController {
    
    private var titleLabel = UILabel()
    private var plusButton = UIButton()
    private var categoriesTableView = UITableView()
    
    private let bag = DisposeBag()
    private let viewModel = CategoriesViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleLabel()
        setupButton()
        setupTable()
        
        bindTable()
        plusTapped()
        
        self.view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:-- Bindings
    func bindTable() {
        viewModel.objects
            .bind(to: categoriesTableView.rx.items(cellIdentifier: "CategoryCell", cellType: CategoryTableViewCell.self)) { row, element, cell in
                cell.categoryLabel.text = element.name
                cell.primaryKey = element.key
            }
            .disposed(by: bag)
    }
    
    func plusTapped() {
        self.plusButton.rx.tap.bind { [self] in
            let popover = ActionPopover()
            popover.modalPresentationStyle = .popover
            popover.viewModel = viewModel
            popover.valueTextField.placeholder = "Название категории"
            let popoverPC = popover.popoverPresentationController
            popoverPC?.delegate = self
            popoverPC?.sourceView = plusButton
            self.present(popover, animated: true)
        }
        .disposed(by: bag)
    }
    //MARK: -- Setup UI
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "Расходы"
        //Constraints:
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupButton() {
        self.view.addSubview(plusButton)
        plusButton.setImage(.add, for: .normal)
        //Constraints:
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            plusButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
    
    func setupTable(){
        self.view.addSubview(categoriesTableView)
        categoriesTableView.delegate = self
        categoriesTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        categoriesTableView.rowHeight = 60
        //Constraints:
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoriesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
//MARK:-- Extensions
extension CategoriesViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить",
                                              handler: { [self]  (contextualAction, view, boolValue) in
                                                viewModel.deleteObject(cell.primaryKey)
                                              })
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    //Push category's costs
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        let viewController = CostsViewController()
        viewController.category = cell.primaryKey
        viewController.title = cell.categoryLabel.text
        if let navigator = navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
