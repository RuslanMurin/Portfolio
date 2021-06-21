import Foundation
import UIKit
import RealmSwift
import RxSwift

//MARK:-- protocol for View Models
protocol MoneyManager {
    var realm: Realm { get }
    var bag: DisposeBag { get }
    
    func addObject(name: String?, value: String)
    
    func deleteObject(_ primaryKey: String)
}

    //MARK:-- Date to String converter (for UI)
extension Date{
    func formatDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
