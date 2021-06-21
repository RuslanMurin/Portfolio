import Foundation
import RealmSwift

class Income: Object {
    @objc dynamic var value = 0
    @objc dynamic var date = Date()
    @objc dynamic var key = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "key"
    }
}
