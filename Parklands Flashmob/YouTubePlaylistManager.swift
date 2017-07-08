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
    private var baseURLString: String {
		return "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(PLAYLIST_ID)&key=\(API_KEY)&maxResults=25"
    }
	private var pageToken: String? = nil
	var endReached: Bool = false
    var videos: [YouTubeVideoData] = []
    
    init(id: String) {
        self.PLAYLIST_ID = id
        super.init()
		
		// Fetch locally cached videos
		let request = NSFetchRequest<YouTubeVideoData>(entityName: "YouTubeVideoData")
		do {
			videos = try CoreDataManager.sharedManager().getContext().fetch(request)
		} catch {
			print("Error")
		}
	}
    
	func getVideos(age: PaginationAge, callback: @escaping ([YouTubeVideoData]?, Error?) -> ()) {
		
		var endpoint: String!
		
		switch age {
		case .newer:
			endpoint = baseURLString
		case .older:
			if !endReached {
				if let token = pageToken {
					endpoint = "\(baseURLString)&pageToken=\(token)"
				} else {
					endpoint = baseURLString
				}
			} else {
				return
			}
		}
		
		print(endpoint)
		
		// HTTP request execution
		URLSession.shared.dataTask(with: URL(string: endpoint)!) { (data, response, err) in
            do {
                // If response from HTTP request is not nil, try to make a JSON object (Dictionary) from it
                if let data = data, let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
					
					// Page token
					self.pageToken = json["nextPageToken"] as? String
					
					// Videos
					let items = (json["items"] as? [[String: Any]])?.reversed()
					
					// Store new videos
                    var newVideos: [YouTubeVideoData] = []
					
					// Iterate through the videos in the playlist
                    for item in items! {
                        if let snippet = (item as [String: Any])["snippet"] as? [String: Any] {
                            
                            let title = snippet["title"] as! String
                            let datePublished = snippet["publishedAt"] as! String
                            let description = snippet["description"] as! String
                            let videoID = (snippet["resourceId"] as! [String:String])["videoId"]!
							
							// Create a record in CoreData model if the video is new
							if (self.videos.filter { $0.videoID == videoID }).count == 0 {
								// Intialization creates record in CoreData
								let newVideo = YouTubeVideoData(title: title, datePublished: datePublished, videoDescription: description, videoID: videoID)
								
								newVideos.append(newVideo)
                                self.videos.append(newVideo)
								
								// Save the CoreData state to store the new video
								CoreDataManager.sharedManager().saveContext()
                            }
                        }
                    }
					
					if age == .older && newVideos.count == 0 {
						self.endReached = true
					}
					
                    callback(newVideos, nil)
                } else {
                    callback(nil, PlaylistError.ResponseError)
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }.resume() // Start request
    }
    
    enum PlaylistError: Error {
        case ResponseError
    }
	
	enum PaginationAge {
		case older
		case newer
	}
}


