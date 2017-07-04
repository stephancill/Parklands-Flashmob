//
//  YouTubePlaylistDAO.swift
//  Parklands Flashmob
//
//  Created by xcode on 2017/07/04.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit

class YouTubePlaylistDAO: NSObject {
    private let apiKey = "AIzaSyA0X7IDaxlQT-gqu4BHIRVh2_GrGrpLxRc"
    private let playlistId: String!
    
    init(id: String) {
        self.playlistId = id
        
        super.init()
    }
}
