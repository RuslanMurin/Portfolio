import UIKit
import RxSwift

class CostPopover: UIViewController {
    
    var nameTextfield = UITextField()
    var valueTextfield = UITextField()
    
    var viewModel: MoneyManager!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTextFields()
        preferredContentSize = CGSize(width: 250, height: 100)
    }
    //MARK: -- Setup TextFields
    func setupTextFields() {
        nameTextfield.placeholder = "Трата"
        valueTextfield.placeholder = "Сумма траты"
        valueTextfield.keyboardType = .numbersAndPunctuation
        
        for tf in [nameTextfield, valueTextfield] {
            view.addSubview(tf)
            tf.backgroundColor = .white
            tf.borderStyle = .roundedRect
            tf.returnKeyType = .done
            tf.delegate = self
            tf.translatesAutoresizingMaskIntoConstraints = false
        }
        //Constraints
        NSLayoutConstraint.activate([
            valueTextfield.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            valueTextfield.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nameTextfield.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameTextfield.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nameTextfield.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            valueTextfield.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension CostPopover: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard nameTextfield.text != "" else {
            let alertController = UIAlertController(title: nil, message: "Имя не должно быть пустым", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alertController, animated: true)
            return false }
        
        guard (Int(valueTextfield.text ?? "") != nil) else {
            let alertController = UIAlertController(title: nil, message: "Сумма должна быть числом", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alertController, animated: true)
            return false }
        viewModel.addObject(name: nameTextfield.text, value: valueTextfield.text ?? "")
        dismiss(animated: true)
        return true
    }
}
