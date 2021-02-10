import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var groupName = ""
    @objc dynamic var key = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "key"
    }
}

class Income: Object {
    @objc dynamic var value = 0
    @objc dynamic var date = Date()
    @objc dynamic var key = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "key"
    }
}

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

