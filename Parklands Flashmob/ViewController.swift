//
//  ViewController.swift
//  Parklands Flashmob
//
//  Created by Stephan Cilliers on 2017/02/20.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import YouTubePlayer

class ViewController: UIViewController {

	var scrollView: UIScrollView!
	var posts: [UIPost] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		/*
		This gets run when the app launches
		*/
		// ...
		// Set up our scroll view
		scrollView = UIScrollView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height))
		scrollView.backgroundColor = UIColor.brown
		self.view.addSubview(scrollView)
		
		self.getPosts(callback: { (posts: [[String:Any]]) in
			// Pass the details to out createVideos method.
			self.createVideos(posts: posts)
		})
	}
	
	func createVideos(posts: [[String: Any]]) {
		for postDetails in posts {
			DispatchQueue.main.async {
				self.posts.append(UIPost(videoDetails: postDetails, parentView: self.scrollView))
			}
		}
	}
	
	func getPosts(callback:@escaping ([[String:Any]])->Void) {
		/*
		Makes a request to the YouTube Data API and gets a list of videos.
		(it then extracts the title, video ID and description, packs it into a diectionary and returns it in a callback function)
		*/
		
		// Request details
		let API_KEY = "AIzaSyA0X7IDaxlQT-gqu4BHIRVh2_GrGrpLxRc"
		let PLAYLIST_ID = "PL5YDelCV-MYBfbzJzCmSldkdBET75RKLr"
		let url = NSURL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(PLAYLIST_ID)&key=\(API_KEY)")
		
		// HTTP request initialization
		var request = URLRequest(url: url as! URL)
		request.httpMethod = "GET"
		let session = URLSession.shared
		
		// HTTP request execution
		session.dataTask(with: request) {data, response, err in
			do {
				// If response from HTTP request is not nil, try to make a JSON object (Dictionary) from it
				if let data = data, let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let items = json["items"] as? [[String: Any]] {
					// List of post details dectionaries
					var posts: [[String:Any]] = []
					// Keeping track of our last post frame processed
					var last: CGRect?
					
					for item in items {
						if let snippet = (item as [String: Any])["snippet"] as? [String: Any] {
							let title = snippet["title"] as! String
							let description = snippet["description"] as! String
							let videoID = (snippet["resourceId"] as! [String:String])["videoId"]!
							let frame: CGRect!
							
							// If lastPostFrame == nil, then we are processing our first post frame.
							if let lastPostFrame = last {
								// Not first frame - get the bottom of the previous frame and set it as the top of the next frame
								frame = CGRect(x: 0, y: lastPostFrame.maxY+20, width: self.view.frame.width, height: 200)
							} else {
								// First frame - set the top of the frame to the top of the parent view
								frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
							}
							last = frame // Update last frame
							
							// Build post details dictionary
							/*
							"title": title,				(String)
							"description": description,	(String)
							"frame": frame,				(CGRect)
							"videoID": videoID			(String)
							*/
							// > 1 type (String and CGRect) means that we have a dictionary where a String is key and Any is the value.
							var details: [String: Any] = [:]
							details["title"] = title
							details["description"] = description
							details["frame"] = frame
							details["videoID"] = videoID
							
							// Add the details dictionary to our list of post dictionaries.
							posts.append(details)
						}
					}
					// Call callback method with post details dictionaries as an argument
					callback(posts)
					
					// Troubleshooting
					/* Fails to initialize YoutubePlayerView */
					// http://stackoverflow.com/questions/41874141/uiwebview-crash-with-error-exc-breakpoint-code-exc-i386-bpt-subcode-0x0#
					
					/* nw_socket_set_common_sockopts setsockopt SO_NOAPNFALLBK failed: [42] Protocol not available, dumping backtrace: */
					// http://stackoverflow.com/questions/39545603/error-protocol-not-available-dumping-backtrace#40330175
				}
			} catch {
				print("Error deserializing JSON: \(error)")
			}
		}.resume() // Start doing everything we just coded up
	}
	
	
}

