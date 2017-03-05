//
//  Post.swift
//  Parklands Flashmob
//
//  Created by Stephan Cilliers on 2017/03/02.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit

class Post: UIView {
	init(frame: CGRect, color: UIColor) {
		super.init(frame: frame)
		self.backgroundColor = color
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
