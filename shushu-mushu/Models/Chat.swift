//
//  Chat.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 23.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import Foundation

struct Chat {
    let partner: String
    let lastMessageTimestamp: TimeInterval
    
    init?(dictionary: [String: Any]) {
        guard let partner = dictionary["partner"] as? String, let timestamp = dictionary["lastMessageTimestamp"] as? TimeInterval else {
            return nil
        }
        
        self.partner = partner
        self.lastMessageTimestamp = timestamp
    }
}
