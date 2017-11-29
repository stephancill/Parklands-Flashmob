//
//  PlaylistPickerCell.swift
//  Parklands Flashmob
//
//  Created by Stephan Cilliers on 2017/11/29.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit

class PlaylistPickerCell: UICollectionViewCell {
	var pickerView: UIPickerView! {
		didSet {
			self.subviews.forEach {$0.removeFromSuperview()}
			self.addSubview(pickerView)
			pickerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
			pickerView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
			pickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
			pickerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
