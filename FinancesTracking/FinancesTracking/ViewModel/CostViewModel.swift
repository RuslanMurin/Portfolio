import Foundation
import RealmSwift

class CostViewModel {
    static let shared = CostViewModel()
    private let realm = try? Realm()
    
    public var categories = Array(try! Realm().objects(Category.self)).sorted{$1.groupName > $0.groupName}
    public var costs = Array(try! Realm().objects(Cost.self)).sorted{$1.date < $0.date}
    public var sum = Array(try! Realm().objects(Cost.self)).reduce(0){$0 + $1.value}
    
    //--------------------Update Realm--------------------
    func fetchAll(){
        categories = Array(try! Realm().objects(Category.self)).sorted{$1.groupName > $0.groupName}
        costs = Array(try! Realm().objects(Cost.self)).sorted{$1.date < $0.date}
        sum = Array(try! Realm().objects(Cost.self)).reduce(0){$0 + $1.value}
    }
    //--------------------Add Objects--------------------
    func addCategory(_ name: String){
        guard  name != "" else { return }
        try? realm?.write{
            let category = Category()
            category.groupName = name
            realm?.add(category, update: .modified)
        }
        fetchAll()
    }
    
    func addCost(forKey: String, named: String, value: String) {
        guard let convertedValue = Int(value) else {return}
        try? realm?.write{
            let cost = Cost()
            cost.category = realm?.object(ofType: Category.self, forPrimaryKey: forKey)
            cost.name = named
            cost.value = convertedValue
            realm?.add(cost, update: .modified)
        }
        fetchAll()
    }
    //--------------------Find Objects--------------------
    func findCategory(_ key: String) -> Category?{
        return realm?.object(ofType: Category.self, forPrimaryKey: key)
    }
    
    func findCost(_ key: String) -> Cost?{
        return realm?.object(ofType: Cost.self, forPrimaryKey: key)
    }
    
    func findCostsByKey(key: String) -> [Cost]{
        guard let result = realm?.objects(Cost.self).filter("category.key == %@", key) else { return [] }
        return Array(result).sorted{$1.date < $0.date}
    }
    
    func findCostsByDate(from: Date, to: Date) -> [Cost]{
        guard let result = realm?.objects(Cost.self).filter("date <= %@ AND date >= %@", to, from) else {return []}
        return Array(result).sorted{$1.date < $0.date}
    }
    
    func findCostsByCategoryAndDate(key: String, from: Date, to: Date) -> [Cost]{
        let predicate1 = NSPredicate(format: "category.key == %@", argumentArray: [key])
        let predicate2 = NSPredicate(format: "date <= %@ AND date >= %@", argumentArray: [to, from])
        let compound = NSCompoundPredicate(type: .and, subpredicates: [predicate1,predicate2])
        guard let result = realm?.objects(Cost.self).filter(compound) else { return[] }
        return Array(result).sorted{$1.date < $0.date}
    }
    //--------------------Delete Objects--------------------
    func deleteCategory(_ withKey: String){
        try? realm?.write{
            realm?.delete(findCostsByKey(key: withKey))
            guard let category = findCategory(withKey) else {return}
            realm?.delete(category)
        }
        fetchAll()
    }
    
    func deleteCost(_ withKey: String){
        try? realm?.write{
            guard let object = findCost(withKey) else {return}
            realm?.delete(object)
        }
        fetchAll()
    }
}
