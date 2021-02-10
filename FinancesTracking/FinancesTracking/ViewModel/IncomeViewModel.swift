import Foundation
import RealmSwift

class IncomeViewModel{
    static let shared = IncomeViewModel()
    private let realm = try? Realm()
    
    public var incomes = Array(try! Realm().objects(Income.self)).sorted{$1.date < $0.date}
    public var sum = Array(try! Realm().objects(Income.self)).reduce(0){$0 + $1.value}
    
    //--------------------Update Realm--------------------
    func fetchAll(){
        incomes = Array(try! Realm().objects(Income.self)).sorted{$1.date < $0.date}
        sum = Array(try! Realm().objects(Income.self)).reduce(0){$0 + $1.value}
    }
    //--------------------Add Objects--------------------
    func addIncome(_ value: String){
        guard let convertedValue = Int(value) else {return}
        try? realm?.write{
            let income = Income()
            income.value = convertedValue
            realm?.add(income, update: .modified)
        }
    }
    //--------------------Find Objects--------------------
    func findObject(_ key: String) -> Income?{
        return realm?.object(ofType: Income.self, forPrimaryKey: key)
    }
    
    func findIncomesByDate(from: Date, to: Date) -> [Income]{
        guard let result = realm?.objects(Income.self).filter("date <= %@ AND date >= %@", to, from) else {return []}
        return Array(result).sorted{$1.date < $0.date}
    }
    //--------------------Delete Objects--------------------
    func deleteIncome(_ withKey: String){
        try? realm?.write{
            guard let object = findObject(withKey) else {return}
            realm?.delete(object)
        }
        fetchAll()
    }
}
