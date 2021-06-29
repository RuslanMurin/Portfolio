import Foundation
import RxCocoa
import RxSwift

class LandmarksManager {
    
    var landmarks: Observable<Landmarks>
    
    init() {
        if let json = readLocalJSONFile(forName: "landmarkData") {
            let data = try! JSONDecoder().decode(Landmarks.self, from: json)
            landmarks = Observable.just(data)
        }
        else { landmarks = Observable<Landmarks>.just([]) }
    }
}

func readLocalJSONFile(forName name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            return data
        }
    } catch {
        print("error: \(error)")
    }
    return nil
}
