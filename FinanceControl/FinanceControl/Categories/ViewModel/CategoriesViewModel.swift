import Foundation
import RealmSwift
import RxRealm
import RxSwift

class CategoriesViewModel: MoneyManager {

    static let shared = CategoriesViewModel()
    internal let realm = try! Realm()
    internal let bag = DisposeBag()
    var objects: Observable<Array<Category>>
    
    init() {
        objects = Observable.array(from: realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true))
    }
    
    func addObject(name: String?, value: String) {
        let category = Category()
        category.name = value
        Observable.from(object: category)
            .subscribe(realm.rx.add())
            .disposed(by: bag)
    }
    
    func deleteObject(_ primaryKey: String) {
        guard let category = realm.object(ofType: Category.self, forPrimaryKey: primaryKey) else { return }
        try? realm.write{
            realm.delete(realm.objects(Cost.self).filter("category.key == %@", primaryKey))
            realm.delete(category)
        }
    }
}
