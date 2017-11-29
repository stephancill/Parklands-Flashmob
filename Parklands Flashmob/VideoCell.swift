//
//  VideoCell.swift
//  Parklands Flashmob
//
//  Created by xcode on 2017/07/04.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var dateLabel: UILabel!
	var shareButton: UIButton!
	
    private var playerView: YTPlayerView!
	
    var videoID: String? {
        didSet {
			if let id = videoID {
				self.playerView.load(withVideoId: id, playerVars: ["playsInline": true])
			}
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = {
            let label = UILabel(frame: CGRect.init(x: 0, y: 10, width: self.frame.width, height: 20))
            label.font = UIFont(name: "Helvetica", size: 18)
            label.textColor = .black
            label.numberOfLines = 2
            
            return label
        }()
        self.addSubview(titleLabel)
        
        dateLabel = {
            let label = UILabel(frame: CGRect.init(x: 0, y: 30, width: self.frame.width, height: 20))
            label.font = UIFont(name: "Helvetica", size: 12)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
			label.textAlignment = .left
            return label
        }()
        self.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
		dateLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
		
		self.shareButton = {
			let button = UIButton()
			button.setTitle("Share", for: .normal)
			button.tintColor = .blue
			button.translatesAutoresizingMaskIntoConstraints = false
			return button
		}()
		self.addSubview(self.shareButton)
		self.shareButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
		
		self.playerView = {
			let player = YTPlayerView(frame: CGRect.init(x: 0, y: 80, width: self.frame.width, height: self.frame.width * 3 / 4))
			player.dropShadow()
			player.translatesAutoresizingMaskIntoConstraints = false
			return player
		}()
		self.addSubview(self.playerView)
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if self.playerView != nil {
			self.playerView.frame.origin.y = dateLabel.frame.maxY + 12
		}
		
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
