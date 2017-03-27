//
//  UIPost.swift
//  Parklands Flashmob
//
//  Created by Marcel Erasmus on 2017/03/27.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit

class UIPost: UIView
{
    var titleSubView: UILabel!
    
    init(videoDetails: [String : Any], parentView: UIScrollView)
    {
        let containerFrame = videoDetails["frame"] as! CGRect
        super.init(frame: containerFrame)
        
        let title = videoDetails["title"] as! String
        self.backgroundColor = .red
        titleSubView = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        titleSubView.text = title.uppercased()
        self.addSubview(titleSubView)
        
        
        
        print(videoDetails)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
