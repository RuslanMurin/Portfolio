import Foundation
import RealmSwift
import RxSwift
import RxRealm

class IncomesViewModel: MoneyManager {
    
    static let shared = IncomesViewModel()
    internal let realm = try! Realm()
    internal let bag = DisposeBag()
    public var objects: Observable<Array<Income>>
    public var sum: Observable<Int>
    
    init() {
        objects = Observable.array(from: realm.objects(Income.self).sorted(byKeyPath: "date", ascending: false))
        let costsSum = Observable.array(from: realm.objects(Cost.self)).compactMap { $0.reduce(0) { $0 + $1.value} }
        let incomesSum = objects.compactMap { $0.reduce(0) { $0 + $1.value} }
        sum = Observable.combineLatest(incomesSum, costsSum)
            .compactMap { $0.0 - $0.1 }
    }
    //MARK:-- Create Income
    func addObject(name: String?, value: String) {
        guard let convertedValue = Int(value) else { return }
        let income = Income()
        income.value = convertedValue
        Observable.from(object: income)
            .subscribe(realm.rx.add())
            .disposed(by: bag)
    }
    //MARK:-- Delete Income
    func deleteObject(_ primaryKey: String) {
        guard let income = realm.object(ofType: Income.self, forPrimaryKey: primaryKey) else { return }
        try? realm.write{
            realm.delete(income)
        }
    }
    //MARK:-- Fetching Incomes for Chart
    func findIncomesByDate(from: Date, to: Date) -> [Income] {
        return Array(realm.objects(Income.self).filter("date <= %@ AND date >= %@", to, from)
                        .sorted(byKeyPath: "date", ascending: false))
    }
    
}
