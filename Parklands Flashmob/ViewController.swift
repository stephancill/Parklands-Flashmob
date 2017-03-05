//
//  ViewController.swift
//  Parklands Flashmob
//
//  Created by Stephan Cilliers on 2017/02/20.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		view.backgroundColor = UIColor.red
		
		let post = Post(frame: CGRect(x: 0, y: 0, width: 800, height: 600), color: UIColor.black)
		view.addSubview(post)
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
//	func getPosts() {
//		// Request details
//		let API_KEY = "AIzaSyA0X7IDaxlQT-gqu4BHIRVh2_GrGrpLxRc"
//		let PLAYLIST_ID = "PL5YDelCV-MYBfbzJzCmSldkdBET75RKLr"
//		let url = NSURL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(PLAYLIST_ID)&key=\(API_KEY)")
//		
//		// HTTP request initialization
//		var request = URLRequest(url: url as! URL)
//		request.httpMethod = "GET"
//		let session = URLSession.shared
//		
//		// HTTP request execution
//		session.dataTask(with: request) {data, response, err in
//
//			do {
//				// If response from HTTP request is not nil, try to make a JSON object (Dictionary) from it
//				if let data = data, let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//					if let items = json["items"] as? [[String: Any]] {
//						for item in items {
//							let snippet = (item as [String: Any])["snippet"] as! [String: Any]
//							print(snippet["title"]!)
//							print((snippet["resourceId"] as! [String:String])["videoId"]!)
//						}
//					}
//					//			print(json.description)
//					// new Post
//				}
//			} catch {
//				print("Error deserializing JSON: \(error)")
//			}
//			}.resume()
//	}


}

