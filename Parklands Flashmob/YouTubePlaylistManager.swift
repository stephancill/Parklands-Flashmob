//
//  YouTubePlaylistManager
//  Parklands Flashmob
//
//  Created by xcode on 2017/07/04.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import CoreData

class YouTubePlaylistManager: NSObject {
    private let API_KEY = "AIzaSyA0X7IDaxlQT-gqu4BHIRVh2_GrGrpLxRc"
    private let PLAYLIST_ID: String
    private var url: URL {
        return URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(PLAYLIST_ID)&key=\(API_KEY)")!
    }
    
    var videos: [YouTubeVideoData] = []
    
    init(id: String) {
        self.PLAYLIST_ID = id
        super.init()
		
		let request = NSFetchRequest<YouTubeVideoData>(entityName: "YouTubeVideoData")
		
		do {
			videos = try CoreDataManager.sharedManager().getContext().fetch(request)
		} catch {
			print("Error")
		}
	}
    
    func getVideos(callback: @escaping ([YouTubeVideoData]?, Error?) -> ()) {
		// HTTP request execution
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            do {
                // If response from HTTP request is not nil, try to make a JSON object (Dictionary) from it
                if let data = data, let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let items = (json["items"] as? [[String: Any]])?.reversed() {
                    
                    var newVideos: [YouTubeVideoData] = []
                    
                    for item in items {
                        if let snippet = (item as [String: Any])["snippet"] as? [String: Any] {
                            
                            let title = snippet["title"] as! String
                            let datePublished = snippet["publishedAt"] as! String
                            let description = snippet["description"] as! String
                            let videoID = (snippet["resourceId"] as! [String:String])["videoId"]!
                            
                            let youtubeVideo = YouTubeVideoData(title: title, datePublished: datePublished, videoDescription: description, videoID: videoID)

                            if self.videos.filter({ (video) -> Bool in
                                return youtubeVideo.videoID == video.videoID
                            }).count == 0 {
								print("New")
                                newVideos.append(youtubeVideo)
                                self.videos.append(youtubeVideo)
								CoreDataManager.sharedManager().saveContext()
                            }
                        }
                    }
                    callback(newVideos, nil)
                } else {
                    callback(nil, PlaylistError.ResponseError)
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }.resume() // Start doing everything we just coded up
    }
    
    enum PlaylistError: Error {
        case ResponseError
    }
}


