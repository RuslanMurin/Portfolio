import UIKit
import Kingfisher
import Alamofire

class GamesListViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    private var isDataLoading = false
    
    private var result = [Top]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        requestGames(offset: result.count, completion: { response in
            self.isDataLoading = true
            self.result.append(contentsOf: response.top)
            self.mainTableView.reloadData()
        })
        self.isDataLoading = false
    }
    
    func requestGames(offset: Int, completion: @escaping (Result) -> Void) {
        
        let topListURL = "https://api.twitch.tv/kraken/games/top?&offset=\(offset)"
        
        AF.request(topListURL, method: .get, parameters: nil, headers: ["Accept":"application/vnd.twitchtv.v5+json","Client-ID":"ahuoi1tl0qmqbyi8jo8nitbmuaad7w"], interceptor: nil, requestModifier: nil)
            .responseJSON { response in
                if let data = response.data{
                    let loadedResults = try? JSONDecoder().decode(Result.self, from: data as Data)
                    DispatchQueue.main.async {
                        if let results = loadedResults{
                            completion(results)
                        }
                    }
                }
            }
    }
}

extension GamesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameTableViewCell
        
        cell.nameLabel.text = result[indexPath.row].game.name
        cell.watchersLabel.text = "Viewers: \(result[indexPath.row].viewers)"
        cell.channelsLabel.text = "Channels: \(result[indexPath.row].channels)"
        cell.logoImageView.kf.setImage(with: URL(string: result[indexPath.row].game.box.large))
        cell.logoImageView.kf.indicatorType = .activity
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isDataLoading else { return }
        let currentOffset = scrollView.contentOffset.y
        if currentOffset > mainTableView.contentSize.height - scrollView.frame.size.height{
            
            // область начала загрузки
            loadData() //Подгружаем еще
        }
        self.mainTableView.reloadData()
    }
}
