import Foundation
import RealmSwift
import RxSwift
import RxRealm

final class CostsViewModel: MoneyManager {
    
    internal let realm = try! Realm()
    internal let bag = DisposeBag()
    public var objects: Observable<Array<Cost>>
    private let categoryKey: String
    
    init(categoryKey: String?) {
        if categoryKey == nil {
            objects = Observable.array(from: realm.objects(Cost.self)
                                        .sorted(byKeyPath: "date", ascending: false))
        }
        else { objects = Observable.array(from: realm.objects(Cost.self)
                                            .filter("category.key == %@", categoryKey ?? "")
                                            .sorted(byKeyPath: "date", ascending: false))
        }
        self.categoryKey = categoryKey ?? ""
    }
    //MARK:-- Create Cost
    func addObject(name: String?, value: String) {
        guard let convertedValue = Int(value) else { return }
        let cost = Cost()
        cost.date = Date()
        cost.category = realm.object(ofType: Category.self, forPrimaryKey: categoryKey)
        cost.value = convertedValue
        cost.name = name ?? "Cost"
        Observable.from(object: cost)
            .subscribe(realm.rx.add())
            .disposed(by: bag)
    }
    //MARK:-- Delete Cost
    func deleteObject(_ primaryKey: String) {
        guard let cost = realm.object(ofType: Cost.self, forPrimaryKey: primaryKey) else { return }
        try? realm.write{
            realm.delete(cost)
        }
    }
    //MARK:-- Fetch Costs for Chart
    func findCostsByDate(from: Date, to: Date) -> [Cost] {
        return Array(realm.objects(Cost.self).filter("date <= %@ AND date >= %@", to, from)
                        .sorted(byKeyPath: "date", ascending: false))
    }
}
