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
    var playerView: YouTubePlayerView!
    var videoID: String? {
        get {
            return self.videoID
        }
        set(id) {
            playerView.loadVideoID(videoID: id!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = {
            let label = UILabel()
            label.font = UIFont(name: "Helvetica", size: 16)
            label.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: 20)
            return label
        }()
        self.addSubview(titleLabel)
        
        dateLabel = {
            let label = UILabel()
            label.font = UIFont(name: "Helvetica", size: 12)
            label.frame = CGRect.init(x: 0, y: 20, width: self.frame.width, height: 20)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        self.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        
        playerView = {
            let player = YouTubePlayerView(frame: CGRect.init(x: 0, y: 45, width: self.frame.width, height: 100))
            return player
        }()
        self.addSubview(playerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
