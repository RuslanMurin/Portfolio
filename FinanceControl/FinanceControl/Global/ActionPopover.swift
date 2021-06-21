import UIKit
import RxSwift
//MARK:-- Popover class for Incomes and Categories ViewControllers
class ActionPopover: UIViewController {
    
    var valueTextField = UITextField()
    
    var viewModel: MoneyManager!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTextField()
        preferredContentSize = CGSize(width: 250, height: 100)
    }
    //MARK:-- Setup TextField
    func setupTextField() {
        view.addSubview(valueTextField)
        valueTextField.backgroundColor = .white
        valueTextField.borderStyle = .roundedRect
        valueTextField.returnKeyType = .done
        valueTextField.delegate = self
        //Constraints
        valueTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            valueTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            valueTextField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
    //MARK:-- Return button on keyboard touched
extension ActionPopover: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let value = textField.text else { return false }
        viewModel.addObject(name: nil, value: value)
        dismiss(animated: true)
        return true
    }
}
