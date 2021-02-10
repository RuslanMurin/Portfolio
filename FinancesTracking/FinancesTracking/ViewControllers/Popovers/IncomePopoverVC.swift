import UIKit

class IncomePopoverVC: UIViewController, AddingPopover {
    @IBOutlet weak var valueTextField: UITextField!
    
    var delegate: UpdateDataDelegate?

    @IBAction func okButtonPressed(_ sender: UIButton) {
        guard valueTextField.text != "" else { return }
        IncomeInfrastructure.shared.addIncome(valueTextField.text ?? "0")
        IncomeInfrastructure.shared.fetchAll()
        delegate?.okButtonPressed()
        dismiss(animated: true)
    }
}
