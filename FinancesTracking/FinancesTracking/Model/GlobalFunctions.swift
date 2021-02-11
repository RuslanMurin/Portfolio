import Foundation
import UIKit

//converting date to string format (for UI)
extension Date{
    func formatDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
//Popover's delegate
protocol UpdateDataDelegate {
    func okButtonPressed()
}
protocol AddingPopover: UIViewController {
    var delegate: UpdateDataDelegate? { get set }
}
//-----------Call to show custom popover------------
func setupPopover<T: AddingPopover>(pop: T, parent: UIViewController, identifier: String, sender: UIButton, storyboard: UIStoryboard?) {
    guard let popVC = storyboard?.instantiateViewController(withIdentifier: identifier) as? T else { return }
    popVC.modalPresentationStyle = .popover
    popVC.delegate = parent as? UpdateDataDelegate
    popVC.preferredContentSize = CGSize(width: parent.view.bounds.width, height: 120)
    let popoverVC = popVC.popoverPresentationController
    popoverVC?.delegate = parent as? UIPopoverPresentationControllerDelegate
    popoverVC?.sourceView = sender
    popoverVC?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.maxY, width: 0, height: 0)
    parent.present(popVC, animated: true)

}


