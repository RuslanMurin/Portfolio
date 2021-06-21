import Foundation
import RealmSwift

class Cost: Object {
    @objc dynamic var value = 0
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    @objc dynamic var category: Category!
    @objc dynamic var key = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "key"
    }
}
