//
//  VideoCell.swift
//  Parklands Flashmob
//
//  Created by xcode on 2017/07/04.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    private var playerView: YouTubePlayerView!
    var videoID: String? {
        get {
            return self.videoID
        }
        set(id) {
            DispatchQueue.main.async {
                self.playerView.loadVideoID(videoID: id!)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = {
            let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 20))
            label.font = UIFont(name: "Helvetica", size: 22)
            label.textColor = .black
            label.numberOfLines = 2
            
            return label
        }()
        self.addSubview(titleLabel)
        
        dateLabel = {
            let label = UILabel(frame: CGRect.init(x: 0, y: 20, width: self.frame.width, height: 20))
            label.font = UIFont(name: "Helvetica", size: 12)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
			label.textAlignment = .left
            return label
        }()
        self.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
		dateLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        // UIWebView cannot be initialized on background thread
        DispatchQueue.main.async {
            self.playerView = {
                let player = YouTubePlayerView(frame: CGRect.init(x: 0, y: 70, width: self.frame.width, height: self.frame.width * 3 / 4))
                player.dropShadow()
                player.translatesAutoresizingMaskIntoConstraints = false
                return player
            }()
            self.addSubview(self.playerView)
//            self.playerView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 10).isActive = true
        }
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
