//
//  Api.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 23.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import Foundation
import Firebase

struct Api {
    
    static func sendChatMessageWith(text: String, receiver: String, inChat chatId: String) {
        guard let loggedUser = Auth.auth().currentUser, let loggedUserEmail = loggedUser.email else {
            return
        }
        
        let message: [String: Any] = [
            "sender": loggedUserEmail,
            "text": text,
            "dateCreated": ServerValue.timestamp()
        ]
        
        Database.database().reference().child("chats/\(chatId.encodedFirebaseKey)/messages").childByAutoId().setValue(message)
        
        let loggedUserChatUpdate: [String: Any] = [
            "chatId": chatId,
            "partner": receiver,
            "lastMessageTimestamp": ServerValue.timestamp()
        ]
        Database.database().reference().child("users/\(loggedUser.uid)/chats/\(receiver.encodedFirebaseKey)").setValue(loggedUserChatUpdate)
        
        Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: receiver).observeSingleEvent(of: .value) { (snapshot) in
            guard let responseDictionary = snapshot.value as? [String:AnyObject], let partnerUid = responseDictionary.keys.first else {
                return
            }
            
            let chatUpdate: [String: Any] = [
                "chatId": chatId,
                "partner": loggedUserEmail,
                "lastMessageTimestamp": ServerValue.timestamp()
            ]
            
            Database.database().reference().child("users/\(partnerUid)/chats/\(loggedUserEmail.encodedFirebaseKey)").setValue(chatUpdate)
        }
    }
}
