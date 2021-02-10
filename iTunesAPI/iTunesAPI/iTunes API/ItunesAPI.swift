import Foundation
import Alamofire

class ItunesAPI {
    
    class func getAlbums(searchRequest: String, completion: @escaping (SearchResults) -> Void){
        
        let convertedString = searchRequest.reduce(""){ $1 == " " ? "\($0)+" : "\($0)\($1)"}
        
        AF.request("https://itunes.apple.com/search?term=\(convertedString)&entity=album").responseJSON{ response in
            if let data = response.data{
                let loadedResults = try? JSONDecoder().decode(SearchResults.self, from: data as Data)
                DispatchQueue.main.async {
                    if let results = loadedResults{
                        completion(results)
                    }
                }
            }
        }
    }
    
    class func getSongs (albumID: Int, completion: @escaping (SongsResult) -> Void){
        
        let convertedID = String(albumID)
        
        AF.request("https://itunes.apple.com/lookup?id=\(convertedID)&entity=song").responseJSON{ response in
            if let data = response.data{
                let loadedSongs = try? JSONDecoder().decode(SongsResult.self, from: data as Data)
                DispatchQueue.main.async {
                    if let songs = loadedSongs{
                        completion(songs)
                    }
                }
            }
        }
    }
    
}

