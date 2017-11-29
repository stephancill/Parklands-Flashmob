//
//  CollectionViewController.swift
//  Parklands Flashmob
//
//  Created by xcode on 2017/07/04.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import MessageUI

class CollectionViewController: UIViewController {
	
    var collectionView: UICollectionView!
    var collectionViewLayout: UICollectionViewFlowLayout!
	var playlistManager: YouTubePlaylistManager! {
		didSet {
			self.collectionView.reloadData()
		}
	}
	
	var playlistManagers: [YouTubePlaylistManager] = []
	var playlistTitles: [String] = []
	
	var pickerView: UIPickerView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.titleView = {
			let imageView = UIImageView(image: #imageLiteral(resourceName: "logo-icon"))
			imageView.contentMode = .scaleAspectFit
			return imageView
		}()
		
		edgesForExtendedLayout = []
		
		navigationController?.navigationBar.barTintColor = .white
		navigationController?.navigationBar.tintColor = .black
		navigationController?.navigationBar.backgroundColor = .white

		// Set navbar button items
		navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(presentCamera)), animated: true)
		
		pickerView = {
			let view = UIPickerView(frame: CGRect.zero)
			view.dataSource = self
			view.delegate = self
			view.translatesAutoresizingMaskIntoConstraints = false
			return view
		}()
		
        // Create layout for collectionView
        collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            return layout
        }()
		
        // Create collectionView
        collectionView = {
            let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
			view.backgroundColor = .white
			view.delegate = self
            view.dataSource = self
            view.register(VideoCell.self, forCellWithReuseIdentifier: "cell")
			view.register(PlaylistPickerCell.self, forCellWithReuseIdentifier: "pickerCell")
            view.refreshControl = {
                let control = UIRefreshControl()
                control.tintColor = .black
                control.addTarget(self, action: #selector(handleRefresh(sender:)), for: .valueChanged)
                return control
            }()
			view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
	
		
		// Populate playlists
		getPlaylists(channelId: "UCnmD8ZNqIfmE2uhfqtwHNlw")
        
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
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let translation = scrollView.panGestureRecognizer.translation(in: self.view)
		
		// Hide or unhide navigation bar
		if translation.y < -50  {
			self.navigationController?.setNavigationBarHidden(true, animated: true)
			UIApplication.shared.statusBarView?.backgroundColor = .white
		} else if translation.y > 50 {
			self.navigationController?.setNavigationBarHidden(false, animated: true)
			UIApplication.shared.statusBarView?.backgroundColor = .clear
		}
	}
	
    func handleRefresh(sender: UIRefreshControl) {
        // Fetch videos and alert CollectionView once done
		guard let playlistManager = self.playlistManager else {return}
		playlistManager.getVideos(age: .newer) { (newVideos, error) in
            if let videos = newVideos {
                if videos.count > 0 {
					self.playlistManager.videos.sort(by: { (videoX, videoY) -> Bool in
						return videoX.date.timeIntervalSince1970 > videoY.date.timeIntervalSince1970
					})
					DispatchQueue.main.async {
						self.collectionView.reloadData()
					}
                }
            }
			
			DispatchQueue.main.async {
				sender.endRefreshing()
			}
        }
    }
	
	func handleSwipe(sender: UISwipeGestureRecognizer) {
		print(sender.direction)
	}
	
	func getPlaylists(channelId: String) {
		let API_KEY = "AIzaSyA0X7IDaxlQT-gqu4BHIRVh2_GrGrpLxRc"
		let endpoint = "https://www.googleapis.com/youtube/v3/playlists?&channelId=\(channelId)&part=snippet&key=\(API_KEY)"
	
		URLSession.shared.dataTask(with: URL(string: endpoint)!) { (data, response, err) in
			do {
				// If response from HTTP request is not nil, try to make a JSON object (Dictionary) from it
				if let data = data, let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
					
					let items = json["items"] as! [[String:Any]]

					self.playlistManagers = items.map({ (item) -> YouTubePlaylistManager in
						return YouTubePlaylistManager(id: item["id"] as! String)
					})
					
					self.playlistTitles = items.map({ (item) -> String in
						return (item["snippet"] as! [String:Any])["title"] as! String
					})
					
					DispatchQueue.main.async {
						self.pickerView.reloadAllComponents()
						self.pickerView(self.pickerView, didSelectRow: 0, inComponent: 0)
					}
					
				}
			} catch {
				print("Error deserializing JSON: \(error)")
			}
		}.resume() // Start request
	}
}

extension CollectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return playlistManagers.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return playlistTitles[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if self.playlistManager != playlistManagers[row] {
			self.playlistManager = playlistManagers[row]
		}
		
		// Refresh
		collectionView.refreshControl?.beginRefreshing()
		handleRefresh(sender: collectionView.refreshControl!)
	}
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if indexPath.section == 0 {
			return CGSize(width: self.view.frame.width - 30, height: 150)
		} else {
			return CGSize(width: self.view.frame.width - 30, height: self.view.frame.width)
		}
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if indexPath.section == 0 {
			// Playlist picker
			let cell: PlaylistPickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickerCell", for: indexPath) as! PlaylistPickerCell
			if cell.pickerView == nil {
				cell.pickerView = self.pickerView
			}
			return cell
		}
		
		let cell: VideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCell
		
		guard let playlistManager = self.playlistManager else {
			return cell
			
		}
		
		if indexPath.row <= playlistManager.videos.count - 1 {
			let video = playlistManager.videos[indexPath.row]
			if cell.videoID == nil || cell.videoID != video.videoID {
				if let videoID = video.videoID {
					cell.titleLabel.text = video.title
					cell.titleLabel.sizeToFit()
					cell.dateLabel.text = video.timeAgo
					cell.videoID = videoID
				}
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if indexPath.section == 0 { return }
		guard let playlistManager = self.playlistManager else {
			print("PlaylistManager not initialized");
			return
		}
		
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
		if section == 0 {
			// Playlist picker
			return 1
		}
		
		guard let playlistManager = self.playlistManager else { return 0 }
		return playlistManager.videos.count
	}
}

extension CollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {
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
			composeMessage(image: image)
		}
		picker.dismiss(animated: false, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	func composeMessage(image: UIImage) {
		let composeVC = MFMessageComposeViewController()
		composeVC.messageComposeDelegate = self

		// Configure the fields of the interface.
		composeVC.recipients = ["flashmob@parklands.co.za"]
		composeVC.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, typeIdentifier: "public.jpeg", filename: "\(Date()).jpeg")

		// Present the view controller modally.
		self.present(composeVC, animated: true, completion: nil)
	}
	
	func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
		print("dismissed")
		controller.dismiss(animated: true, completion: nil)
	}
}
