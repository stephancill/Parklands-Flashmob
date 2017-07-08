//
//  CameraViewController.swift
//  Parklands Flashmob
//
//  Created by Stephan Cilliers on 2017/05/22.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import MessageUI

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
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
        navigationItem.title = "📸"
    }
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			composeMail(image: image)
		}
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
		controller.dismiss(animated: true) {
			print("Dismissed")
		}
	}
	
	override func viewWillLayoutSubviews() {
		self.viewDidLoad()
	}
}
