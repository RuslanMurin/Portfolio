import Foundation
import Alamofire
import ReactiveKit
import Bond

class ViewModel{
    
    var views: Property<[String]> = Property([])
    var data: Property<[Datum]> = Property([])
    
    init() {
        bind()
    }
    
    private func bind() {
        loadData(completion: { data in
    //MARK: Бинд порядка показа для пикера
            Property(data.view)
            .bind(to: self.views)
    //MARK: Бинд данных для отображения
            Property(data.view ++ data.data)
            .bind(to: self.data)
            })
    }
    //MARK: Можно сделать отдельным файлом
    private func loadData(completion: @escaping (Model) -> Void) {
        AF.request("https://pryaniky.com/static/json/sample.json").responseJSON { response in
            if let data = response.data{
                let loadedData = try? JSONDecoder().decode(Model.self, from: data as Data)
                DispatchQueue.main.async {
                    if let data = loadedData{
                        completion(data)
                    }
                }
            }
        }
    }
}
    //MARK: Пользовательский оперптор для построения данных
infix operator ++
func++ (left: [String], right: [Datum]) -> [Datum] {
    var result: [Datum] = []
    for name in left {
        result.append(contentsOf: right.filter { $0.name == name })
    }
    return result
}
