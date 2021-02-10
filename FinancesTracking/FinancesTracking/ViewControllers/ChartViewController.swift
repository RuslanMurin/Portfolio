import UIKit
import Charts

class ChartViewController: UIViewController, ChartViewDelegate{
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    var chartsViewModel = ChartsViewModel.shared
    
    //--------------------Setup Chart View--------------------
    lazy var lineChartView: LineChartView = { () -> LineChartView in
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.xAxis.setLabelCount(7, force: true)
        chartView.xAxis.labelPosition = .bottom
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
        updateChart(days: -7)
    }
    
    @IBAction func segmentChoiced(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            updateChart(days: -7)
        case 1:
            updateChart(days: -31)
        case 2:
            updateChart(days: -93)
        case 3:
            updateChart(days: -3650)
        default:
            break
        }
    }
    
    func updateChart(days: Int){
        let set1 = LineChartDataSet(entries: chartsViewModel.fetchCosts(days: days).sorted{$0.x < $1.x}, label: "Расходы")
        set1.drawCirclesEnabled = false
        set1.mode = .linear
        set1.lineWidth = 3
        set1.setColor(.systemRed)
        
        let set2 = LineChartDataSet(entries: chartsViewModel.fetchIncomes(days: days).sorted{$0.x < $1.x}, label: "Доходы")
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
}

//--------------------Convert Dates values to String format--------------------
extension ChartViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value * 86400))
    }
}
