import UIKit

class IncomePopoverVC: UIViewController, AddingPopover {
    @IBOutlet weak var valueTextField: UITextField!
    
    var delegate: UpdateDataDelegate?

    @IBAction func okButtonPressed(_ sender: UIButton) {
        guard valueTextField.text != "" else { return }
        IncomeViewModel.shared.addIncome(valueTextField.text ?? "0")
        IncomeViewModel.shared.fetchAll()
        delegate?.okButtonPressed()
        dismiss(animated: true)
    }
}
