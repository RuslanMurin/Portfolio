import UIKit

class GroupPopoverVC: UIViewController, AddingPopover {
    @IBOutlet weak var nameTextField: UITextField!
    
    var delegate: UpdateDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
    }
}

extension GroupPopoverVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard nameTextField.text != "" else { return false}
        CostViewModel.shared.addCategory(nameTextField.text ?? "")
        CostViewModel.shared.fetchAll()
        delegate?.okButtonPressed()
        dismiss(animated: true)
        return true
    }
}
