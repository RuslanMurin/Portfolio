import UIKit

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var objectsLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var data: Result?
    var songs: [Song]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = self.data else { return }
        
        albumNameLabel.text = data.collectionName
        artistLabel.text = data.artistName
        genreLabel.text = data.primaryGenreName
        objectsLabel.text = "Objects: \(data.trackCount)"
        releaseLabel.text = "Release: \(data.releaseDate)"
        artworkImageView.kf.setImage(with: URL(string: data.artworkUrl100))
        artworkImageView.kf.indicatorType = .activity
        
        ItunesAPI.getSongs(albumID: data.collectionId, completion: { songs in
            self.songs = songs.results
            self.songsTableView.reloadData()
        })//call iTunes API
        
    }
    
    func mSecondsToMinutesSeconds (mSecs : Int) -> String {
        let minutes = ((mSecs / 1000) % 3600) / 60
        let seconds = ((mSecs / 1000) % 3600) % 60
        return "\(minutes):\(seconds)"
    }//Convert track time from milli seconds
    
}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        
        if let song = songs?[indexPath.row]{
            
            cell.numberLabel.text = "\(indexPath.row + 1)"
            cell.timeLabel.text = mSecondsToMinutesSeconds(mSecs: song.trackTimeMillis)
            cell.songLabel.text = song.trackName
        }
        
        return cell
    }
    
}
