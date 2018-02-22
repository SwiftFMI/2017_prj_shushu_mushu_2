//
//  ChatMessage.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 22.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import Foundation
import FirebaseAuth

struct ChatMessage {
    var author: String
    var text: String
    var timestamp: TimeInterval
    
    init?(dictionary: [String: Any]) {
        guard let text = dictionary["text"] as? String, let author = dictionary["sender"] as? String, let timestamp = dictionary["dateCreated"] as? TimeInterval else {
            return nil
        }
        
        self.text = text
        self.author = author
        self.timestamp = timestamp
    }
    
    var isFromLoggedUser: Bool {
        return author == Auth.auth().currentUser?.email
    }
}
