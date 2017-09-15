//
//  UINavigationBarExtension.swift
//  Parklands Flashmob
//
//  Created by Stephan Cilliers on 2017/09/15.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit

//https://stackoverflow.com/questions/31756230/uinavigationbar-set-custom-shadow-in-appdelegate-swift
extension UINavigationBar {
	var castShadow : String {
		get { return "anything fake" }
		set {
			self.layer.shadowOffset = CGSize(width: 0, height: -10)
			self.layer.shadowRadius = 10.0
			self.layer.shadowColor = UIColor.black.cgColor
			self.layer.shadowOpacity = 0.1
		}
	}
}
