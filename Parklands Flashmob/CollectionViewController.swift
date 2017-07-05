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
        
        // Fetch videos and alert CollectionView once done
        playlistManager.getVideos { (videos, error) in
            self.collectionView.reloadData()
        }
        
        // Create CollectionView
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        
        collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cell")
        
        self.view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let video = playlistManager.videos[indexPath.row]
        let cell: VideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCell
        cell.titleLabel.text = video.title
        cell.dateLabel.text = video.timeAgo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistManager.videos.count
    }

}
