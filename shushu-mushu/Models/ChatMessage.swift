//
//  ChatMessage.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 22.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import Foundation
import FirebaseAuth

final class ChatMessage {
    let author: String
    let text: String?
    let imageUrl: String?
    let timestamp: TimeInterval
    
    var rowHeight: CGFloat = 0
    
    init?(dictionary: [String: Any]) {
        if let text = dictionary["text"] as? String {
            self.text = text
            self.imageUrl = nil
            
        } else if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
            self.text = nil
            
        } else {
            return nil
        }
        
        guard let author = dictionary["sender"] as? String, let timestamp = dictionary["dateCreated"] as? TimeInterval else {
            return nil
        }
        
        self.author = author
        self.timestamp = timestamp
    }
    
    var isFromLoggedUser: Bool {
        return author == Auth.auth().currentUser?.email
    }
}
