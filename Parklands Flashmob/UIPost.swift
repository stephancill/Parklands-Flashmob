//
//  UIPost.swift
//  Parklands Flashmob
//
//  Created by Stephan Cilliers on 2017/03/27.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit

class UIPost: UIView {

	var titleSubview: UILabel!
	
	init(videoDetails: [String:Any], parentView: UIScrollView) {
		// Extend the scrollView as new videos are added.
		let frame = videoDetails["frame"] as! CGRect
		
		if frame.maxY > parentView.frame.height {
			parentView.contentSize = CGSize(width: parentView.frame.width, height: frame.maxY)
		}
		
		super.init(frame: frame)
		
		// Placeholder background color
		self.backgroundColor = .yellow
		
		// Initialize subviews
		let title = videoDetails["title"] as! String
		titleSubview = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
		titleSubview.text = title
		
		// Add subviews
		self.addSubview(titleSubview)
		
		
		// Add to parent view
		parentView.addSubview(self)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
