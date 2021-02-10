import UIKit

class CostPopoverVC: UIViewController, AddingPopover {
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var categoryKey = ""
    var delegate: UpdateDataDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
    }
    
}
extension CostPopoverVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard valueTextField.text != "" && nameTextField.text != "" else { return false}
        CostInfrastructure.shared.addCost(forKey: self.categoryKey, named: nameTextField.text ?? "none", value: valueTextField.text ?? "0")
        CostInfrastructure.shared.fetchAll()
        dismiss(animated: true, completion: {self.delegate?.okButtonPressed()})
        return true
    }
}
