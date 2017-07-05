//
//  YouTubeVideo.swift
//  Parklands Flashmob
//
//  Created by xcode on 2017/07/04.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit

struct YouTubeVideo {
    var title: String
    var datePublished: String
    var timeAgo: String {
        let date = ISO8601DateFormatter()
        date.formatOptions = .withFullDate
        let dateString = datePublished
        let dateTime = date.date(from: dateString)
        return dateTime!.timeAgoDisplay()
    }
    var videoDescription: String
    var videoID: String
}


