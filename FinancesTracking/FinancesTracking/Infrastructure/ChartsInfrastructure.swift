import Foundation
import Charts

class ChartsInfrastructure{
    static let shared = ChartsInfrastructure()
    
    let costSingleton = CostInfrastructure.shared
    let incomeSingleton = IncomeInfrastructure.shared
    
    //--------------------Returns Data for incomes line--------------------
    func fetchIncomes(days: Int) -> [BarChartDataEntry] {
        
        var dataEntrys: [BarChartDataEntry] = []
        guard let from = Calendar.current.date(byAdding: .day, value: days, to: Date()) else { return [] }
        let incomes = self.incomeSingleton.findIncomesByDate(from: from, to: Date())
        
        for i in 0..<incomes.count{
            let timeIntervalForDate: TimeInterval = Double(incomes[i].date.timeIntervalSince1970 / 86400).rounded()
            let dataEntry = BarChartDataEntry(x: timeIntervalForDate, y: Double(incomes[i].value))
            dataEntrys.last?.x == dataEntry.x
                ? dataEntrys.last?.y += dataEntry.y
                : dataEntrys.append(dataEntry)
        }
        return dataEntrys
    }
    //--------------------Returns data for Costs line--------------------
    func fetchCosts(days: Int)->[BarChartDataEntry]{
        
        var dataEntrys: [BarChartDataEntry] = []
        guard let from = Calendar.current.date(byAdding: .day, value: days, to: Date()) else { return [] }
        let costs = self.costSingleton.findCostsByDate(from: from, to: Date())
        
        for i in 0..<costs.count{
            let timeIntervalForDate: TimeInterval = Double(costs[i].date.timeIntervalSince1970 / 86400).rounded()
            let dataEntry = BarChartDataEntry(x: timeIntervalForDate, y: Double(costs[i].value))
            dataEntrys.last?.x == dataEntry.x
                ? dataEntrys.last?.y += dataEntry.y
                : dataEntrys.append(dataEntry)
        }
        return dataEntrys
    }
    //--------------------Returns Data for incomes chart by Category---------------
    func fetchCostsByCategory(categoryKey: String, days: Int) -> [BarChartDataEntry]{
        
        var dataEntrys: [BarChartDataEntry] = []
        guard let from = Calendar.current.date(byAdding: .day, value: days, to: Date()) else { return [] }
        let costs = self.costSingleton.findCostsByCategoryAndDate(key: categoryKey, from: from, to: Date())
        
        for i in 0..<costs.count{
            let timeIntervalForDate: TimeInterval = Double(costs[i].date.timeIntervalSince1970 / 86400).rounded()
            let dataEntry = BarChartDataEntry(x: timeIntervalForDate, y: Double(costs[i].value))
            dataEntrys.last?.x == dataEntry.x
                ? dataEntrys.last?.y += dataEntry.y
                : dataEntrys.append(dataEntry)
        }
        return dataEntrys
    }
}


