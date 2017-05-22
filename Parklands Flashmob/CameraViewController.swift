//
//  CameraViewController.swift
//  Parklands Flashmob
//
//  Created by Stephan Cilliers on 2017/05/22.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit
import SwiftyCam
import MessageUI

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate, MFMailComposeViewControllerDelegate {

	var captureButton: SwiftyCamButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let buttonRadius: CGFloat = 50
		captureButton = SwiftyCamButton(frame: CGRect.init(x: self.view.frame.width/2 - buttonRadius / 2, y: self.view.frame.height - 10 - buttonRadius, width: buttonRadius, height: buttonRadius))
		captureButton.layer.cornerRadius = buttonRadius/2
		captureButton.layer.borderColor = UIColor.white.cgColor
		captureButton.layer.borderWidth = 2
		captureButton.delegate = self
		
		cameraDelegate = self
		
		self.view.addSubview(captureButton)
		
        navigationItem.title = "📸"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
		composeMail(image: photo)
	}
	
	func composeMail(image: UIImage) {
		let mailComposeVC = MFMailComposeViewController()
		
		mailComposeVC.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "\(Date()).jpeg")
		mailComposeVC.setSubject("My Flashmob Submission")
		mailComposeVC.setMessageBody("<html><body><p>Hey, please find a photo I've taken attached via the Flashmob app attached.</p></body></html>", isHTML: true)
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
