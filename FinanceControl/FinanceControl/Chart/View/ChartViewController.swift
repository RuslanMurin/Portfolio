import UIKit
import Charts
import RxSwift
import RxCocoa

class ChartViewController: UIViewController, ChartViewDelegate {
    
    private var segmentedControl = UISegmentedControl()
    lazy var lineChartView = LineChartView()
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    weak var chartViewModel = ChartViewModel.shared
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControl()
        setupChartView()
        
        choicedSegment()
        segmentedControl.selectedSegmentIndex = 0
        updateChart(days: -7)
        self.view.backgroundColor = .systemBackground
    }
    
    //MARK:-- Segmented Control Actions
    func choicedSegment() {
        segmentedControl.rx.value.bind {value in
            switch value {
            case 0:
                self.updateChart(days: -7)
            case 1:
                self.updateChart(days: -31)
            case 2:
                self.updateChart(days: -93)
            case 3:
                self.updateChart(days: -3650)
            default:
                break
            }
        }
        .disposed(by: self.bag)
    }
    
    func updateChart(days: Int) {
        let set1 = LineChartDataSet(entries: chartViewModel?.fetchCosts(days: days).sorted{$0.x < $1.x}, label: "Расходы")
        set1.drawCirclesEnabled = false
        set1.mode = .linear
        set1.lineWidth = 3
        set1.setColor(.systemRed)
        
        let set2 = LineChartDataSet(entries: chartViewModel?.fetchIncomes(days: days).sorted{$0.x < $1.x}, label: "Доходы")
        set2.drawCirclesEnabled = false
        set2.mode = .linear
        set2.lineWidth = 3
        set2.setColor(.systemGreen)
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setDrawValues(false)
        
        lineChartView.data = data
        let xAxis = lineChartView.xAxis
        xAxis.valueFormatter = axisFormatDelegate
    }
    //MARK: -- Setup UI
    func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.insertSegment(withTitle: "Неделя", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Месяц", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Квартал", at: 2, animated: true)
        segmentedControl.insertSegment(withTitle: "Все", at: 3, animated: true)
        //Constraints:
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            segmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func setupChartView() {
        view.addSubview(lineChartView)
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.setLabelCount(7, force: true)
        lineChartView.xAxis.labelPosition = .bottom
        axisFormatDelegate = self
        lineChartView.frame = CGRect(x: self.view.bounds.minX + 5,
                                     y: self.view.frame.midY - self.view.bounds.width / 2 - 10,
                                     width: self.view.bounds.width - 10,
                                     height: self.view.bounds.width - 10)
    }
}
//MARK:-- Extensions
extension ChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value * 86400))
    }
}
