//
//  UIPost.swift
//  Parklands Flashmob
//
//  Created by Stephan Cilliers on 2017/03/27.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import YouTubePlayer

class UIPost: UIView {

	var titleSubview: UIScrollView!
	var titleLabel: UILabel!
	var videoView: YouTubePlayerView!
	
	init(videoDetails: [String:Any], parentView: UIScrollView) {
		// Extend the scrollView as new videos are added.
		
		let frame = videoDetails["frame"] as! CGRect
		
		if frame.maxY > parentView.frame.height {
			parentView.contentSize = CGSize(width: parentView.frame.width, height: frame.maxY)
		}
		
		super.init(frame: frame)
		
		self.dropShadow()
		
		// Placeholder background color
		self.backgroundColor = .white
		
		// Initialize subviews
		titleSubview = UIScrollView(frame: CGRect(x: 10, y: 2, width: self.frame.width, height: 40))
		titleSubview.showsHorizontalScrollIndicator = false
		
		let date = ISO8601DateFormatter()
		date.formatOptions = .withFullDate
		let dateString = videoDetails["date"] as! String
		let dateTime = date.date(from: dateString)
		
		titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width*2, height: 40))
		titleLabel.text = dateTime?.timeAgoDisplay()
		
		titleSubview.contentSize.width = titleLabel.intrinsicContentSize.width
		titleSubview.addSubview(titleLabel)

		
		let videoView = YouTubePlayerView(frame: CGRect(x: 0, y: 40, width: self.frame.width, height: self.frame.height-40))
		videoView.loadVideoID(videoID: videoDetails["videoID"] as! String)
		// Add subviews
		self.addSubview(titleSubview)
		self.addSubview(videoView)
		
		
		// Add to parent view
		parentView.addSubview(self)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension UIView {
	
	func dropShadow() {
		
		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0.5
		self.layer.shadowOffset = CGSize(width: -1, height: 3)
		self.layer.shadowRadius = 1
		
		self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
		self.layer.shouldRasterize = true
	}
}

extension Date {
	func timeAgoDisplay() -> String {
		let secondsAgo = Int(Date().timeIntervalSince(self))
		
		let minute = 60
		let hour = 60 * minute
		let day = 24 * hour
		let week = 7 * day
		let month = 4 * week
		
		if secondsAgo < minute {
			return "just now"
		} else if secondsAgo < hour {
			return "\(secondsAgo / minute) minute\((secondsAgo / minute > 1 ? "s" : "")) ago"
		} else if secondsAgo < day {
			return "\(secondsAgo / hour) hour\((secondsAgo / hour > 1 ? "s" : "")) ago"
		} else if secondsAgo < week {
			return "\(secondsAgo / day) day\((secondsAgo / day > 1 ? "s" : "")) ago"
		} else if secondsAgo < month {
			return "\(secondsAgo / week) week\((secondsAgo / week > 1 ? "s" : "")) ago"
		}
		
		return "\(secondsAgo / month) month\((secondsAgo / month > 1 ? "s" : "")) ago"
	}
}

