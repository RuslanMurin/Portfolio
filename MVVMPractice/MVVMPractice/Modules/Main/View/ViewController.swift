import UIKit
import ReactiveKit
import Bond
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var variantsPicker: UIPickerView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        viewModel.views.bind(to: pickerView)
        pickerView.reactive.selectedRow.observeNext { row in
            
            let datum = self.viewModel.data.value[row.0]
            
            self.label.text = datum.data.text
            
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: URL(string: datum.data.url ?? ""))
            
            Property(datum.data.variants?.compactMap { $0.text } ?? []).bind(to: self.variantsPicker)
        }
        .dispose(in: reactive.bag)
    }
    
    deinit {
        reactive.bag.dispose()
    }
}
