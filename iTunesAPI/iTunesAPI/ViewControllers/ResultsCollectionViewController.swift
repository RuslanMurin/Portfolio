import UIKit
import Kingfisher

class ResultsCollectionViewController: UICollectionViewController{
    
    let searchConroller = UISearchController(searchResultsController: nil)
    var result: SearchResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchConroller
        searchConroller.searchBar.delegate = self
        //setup search bar
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result?.resultCount ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as! ResultCollectionViewCell
        
        cell.albumImage.kf.setImage(with: URL(string: result?.results?[indexPath.row].artworkUrl100 ?? ""))
        cell.albumImage.kf.indicatorType = .activity
        cell.artistLabel.text = result?.results?[indexPath.row].artistName
        cell.albumLabel.text = result?.results?[indexPath.row].collectionName
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlbumVC") as? AlbumViewController {
            viewController.data = result?.results?[indexPath.row]
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension ResultsCollectionViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchConroller.searchBar.endEditing(true)
        ItunesAPI.getAlbums(searchRequest: searchBar.text ?? "", completion: {
            result in
            self.result = nil
            self.result = result
            self.collectionView.reloadData()
        })//calling API
        searchConroller.isActive = false
    }
    
    
    
}
