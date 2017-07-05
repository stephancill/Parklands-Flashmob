//
//  DateExtension.swift
//  Parklands Flashmob
//
//  Created by xcode on 2017/07/04.
//  Copyright © 2017 Stephan Cilliers. All rights reserved.
//

import UIKit

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        if secondsAgo < minute {
            return "just now"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minute\((secondsAgo / minute > 1 ? "s" : "")) ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hour\((secondsAgo / hour > 1 ? "s" : "")) ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) day\((secondsAgo / day > 1 ? "s" : "")) ago"
        } else if secondsAgo < month {
            return "\(secondsAgo / week) week\((secondsAgo / week > 1 ? "s" : "")) ago"
        }
        
        return "\(secondsAgo / month) month\((secondsAgo / month > 1 ? "s" : "")) ago"
    }
}
