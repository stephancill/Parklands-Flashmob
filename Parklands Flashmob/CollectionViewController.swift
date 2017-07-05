//
//  CollectionViewController.swift
//  Parklands Flashmob
//
//  Created by xcode on 2017/07/04.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import YouTubePlayer

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    var collectionViewLayout: UICollectionViewFlowLayout!
    var playlistManager: YouTubePlaylistManager = YouTubePlaylistManager(id: "PL5YDelCV-MYBfbzJzCmSldkdBET75RKLr")
    var videos: [YouTubeVideo] = []
    var colors: [UIColor] = [.red, .red, .yellow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create layout for collectionView
        collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: self.view.frame.width - 30, height: self.view.frame.width - 40)
            return layout
        }()
        
        // Create collectionView
        collectionView = {
            let view = UICollectionView.init(frame: self.view.frame, collectionViewLayout: collectionViewLayout)
            view.backgroundColor = #colorLiteral(red: 0, green: 0.255411133, blue: 0.621219904, alpha: 1)
            view.delegate = self
            view.dataSource = self
            view.register(VideoCell.self, forCellWithReuseIdentifier: "cell")
            view.refreshControl = {
                let control = UIRefreshControl()
                control.tintColor = .white
                control.addTarget(self, action: #selector(handleRefresh(sender:)), for: .valueChanged)
                return control
            }()
            return view
        }()
        
        // Refresh
        collectionView.refreshControl?.beginRefreshing()
        handleRefresh(sender: collectionView.refreshControl!)
        
        self.view.addSubview(collectionView)
    }
    
    func handleRefresh(sender: UIRefreshControl) {
        // Fetch videos and alert CollectionView once done
        playlistManager.getVideos { (newVideos, error) in
            if let videos = newVideos {
                if videos.count > 0 {
                    self.collectionView.reloadData()
                }
            }
            sender.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let video = playlistManager.videos[indexPath.row]
        let cell: VideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCell
        cell.titleLabel.text = video.title
        cell.titleLabel.sizeToFit()
        cell.dateLabel.text = video.timeAgo
        cell.videoID = video.videoID
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistManager.videos.count
    }
}
