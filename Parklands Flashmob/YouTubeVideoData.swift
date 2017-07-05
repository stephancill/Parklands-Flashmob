//
//  YouTubeVideoData.swift
//  Parklands Flashmob
//
//  Created by xcode on 2017/07/05.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import CoreData

class YouTubeVideoData: NSManagedObject {
	
	var timeAgo: String {
		let date = ISO8601DateFormatter()
		date.formatOptions = .withFullDate
		let dateString = datePublished
		let dateTime = date.date(from: dateString!)
		return dateTime!.timeAgoDisplay()
	}
	
	convenience init(title: String, datePublished: String, videoDescription: String, videoID: String) {
		let classStringName = String(describing: YouTubeVideoData.self)
		let entityDescription = NSEntityDescription.entity(forEntityName: classStringName, in: CoreDataManager.sharedManager().getContext())!
		
		self.init(entity: entityDescription, insertInto: CoreDataManager.sharedManager().getContext())
		
		self.title = title
		self.datePublished = datePublished
		self.videoDescription = videoDescription
		self.videoID = videoID
	}
}
