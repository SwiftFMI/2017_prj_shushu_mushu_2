//
//  TimeInterval+Helper.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 24.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var relativeTimeString: String {
        let date = Date(timeIntervalSince1970: self)
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) y ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) M ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) w ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) h ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "Hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) m ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "Minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) s ago"
        }
        
        return "now"
    }
}
