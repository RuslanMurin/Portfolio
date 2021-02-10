import UIKit
import Charts

class CostsChartViewController: UIViewController{
    
    var category: Category?
    weak var axisFormatDelegate: IAxisValueFormatter?
    var chartsViewModel = ChartsViewModel.shared
    
    //--------------------Setup Chart View--------------------
    lazy var lineChartView: LineChartView = { () -> LineChartView in
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.xAxis.setLabelCount(7, force: true)
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        axisFormatDelegate = self
        lineChartView.frame = CGRect(x: self.view.bounds.minX + 5,
                                     y: self.view.frame.midY - self.view.bounds.width / 2 - 10,
                                     width: self.view.bounds.width - 10,
                                     height: self.view.bounds.width - 10)
        updateChart(days: -7, key: category?.key ?? "")
    }
    
    @IBAction func segmentChoiced(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            updateChart(days: -7, key: category?.key ?? "")
        case 1:
            updateChart(days: -31, key: category?.key ?? "")
        case 2:
            updateChart(days: -93, key: category?.key ?? "")
        case 3:
            updateChart(days: -3650, key: category?.key ?? "")
        default:
            break
        }
    }
    
    func updateChart(days: Int, key: String){
        let set = LineChartDataSet(entries: chartsViewModel.fetchCostsByCategory(categoryKey: key, days: days).sorted{$0.x < $1.x}, label: category?.groupName)
        set.drawCirclesEnabled = false
        set.mode = .linear
        set.lineWidth = 3
        set.setColor(.systemRed)

        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        
        lineChartView.data = data
        let xAxis = lineChartView.xAxis
        xAxis.valueFormatter = axisFormatDelegate
    }
}

//--------------------Convert Date values to String--------------------
extension CostsChartViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value * 86400))
    }
}
