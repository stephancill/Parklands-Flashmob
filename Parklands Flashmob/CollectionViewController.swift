//
//  CollectionViewController.swift
//  Parklands Flashmob
//
//  Created by xcode on 2017/07/04.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import YouTubePlayer
import MessageUI

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    var collectionViewLayout: UICollectionViewFlowLayout!
    var playlistManager: YouTubePlaylistManager = YouTubePlaylistManager(id: "PL5YDelCV-MYBfbzJzCmSldkdBET75RKLr")
	
    var colors: [UIColor] = [.red, .red, .yellow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set navbar button items
		navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(presentCamera)), animated: true)
		
        // Create layout for collectionView
        collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: self.view.frame.width - 30, height: self.view.frame.width)
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
			view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // Refresh
        collectionView.refreshControl?.beginRefreshing()
        handleRefresh(sender: collectionView.refreshControl!)
        
        self.view.addSubview(collectionView)
		
		// Constraints
		collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
		collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
		collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
	
	
    
    func handleRefresh(sender: UIRefreshControl) {
        // Fetch videos and alert CollectionView once done
		playlistManager.getVideos(age: .newer) { (newVideos, error) in
            if let videos = newVideos {
                if videos.count > 0 {
					self.playlistManager.videos.sort(by: { (videoX, videoY) -> Bool in
						return videoX.date.timeIntervalSince1970 > videoY.date.timeIntervalSince1970
					})
                    self.collectionView.reloadData()
                }
            }
            sender.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
        let cell: VideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCell
		
		if indexPath.row <= playlistManager.videos.count - 1 {
			let video = playlistManager.videos[indexPath.row]
			cell.titleLabel.text = video.title
			cell.titleLabel.sizeToFit()
			cell.dateLabel.text = video.timeAgo
			cell.videoID = video.videoID
		}

        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let lastElement = playlistManager.videos.count - 1
		if indexPath.row == lastElement {
			// Load more
			playlistManager.getVideos(age: .older) { (newVideos, error) in
				if let videos = newVideos {
					if videos.count > 0 {
						self.playlistManager.videos.sort(by: { (videoX, videoY) -> Bool in
							return videoX.date.timeIntervalSince1970 > videoY.date.timeIntervalSince1970
						})
						self.collectionView.reloadData()
					}
				}
			}
		}
	}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistManager.videos.count
    }
}

extension CollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
	// Camera functionality
	func presentCamera() {
		if (UIImagePickerController.isSourceTypeAvailable(.camera)){
			let picker = UIImagePickerController()
			picker.delegate = self
			picker.sourceType = .camera
			picker.allowsEditing = true
			self.present(picker, animated: true, completion: nil)
		}
		else{
			NSLog("No Camera.")
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			composeMail(image: image)
		}
		picker.dismiss(animated: false, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	func composeMail(image: UIImage) {
		let mailComposeVC = MFMailComposeViewController()
		
		mailComposeVC.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "\(Date()).jpeg")
		mailComposeVC.setSubject("My Flashmob Submission")
		mailComposeVC.setMessageBody("<html><body><p>Sent via the Flashmob app.</p></body></html>", isHTML: true)
		mailComposeVC.setToRecipients(["flashmob@parklands.co.za"])
		
		mailComposeVC.mailComposeDelegate = self
		self.show(mailComposeVC, sender: self)
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
}
