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
        
        Api.updateUsersChats(receiver: receiver, chatId: chatId, loggedUserEmail: loggedUserEmail, loggedUserUid: loggedUser.uid)
    }
    
    static func sendChatMessageWith(image: UIImage, receiver: String, inChat chatId: String) {
        guard let data = UIImageJPEGRepresentation(image, 0.8) else {
            return
        }
        
        // set upload path
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        Storage.storage().reference().child("chat_images/\(UUID().uuidString)").putData(data, metadata: metaData) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let imageUrl = metadata?.downloadURL()?.absoluteString {
                Api.sendChatMessageWith(imageUrl: imageUrl, receiver: receiver, inChat: chatId)
            }
        }
    }
    
    private static func sendChatMessageWith(imageUrl: String, receiver: String, inChat chatId: String) {
        guard let loggedUser = Auth.auth().currentUser, let loggedUserEmail = loggedUser.email else {
            return
        }
        
        let message: [String: Any] = [
            "sender": loggedUserEmail,
            "imageUrl": imageUrl,
            "dateCreated": ServerValue.timestamp()
        ]
        
        Database.database().reference().child("chats/\(chatId.encodedFirebaseKey)/messages").childByAutoId().setValue(message)
        
        Api.updateUsersChats(receiver: receiver, chatId: chatId, loggedUserEmail: loggedUserEmail, loggedUserUid: loggedUser.uid)
    }
    
    private static func updateUsersChats(receiver: String, chatId: String, loggedUserEmail: String, loggedUserUid: String) {
        let loggedUserChatUpdate: [String: Any] = [
            "chatId": chatId,
            "partner": receiver,
            "lastMessageTimestamp": ServerValue.timestamp()
        ]
        Database.database().reference().child("users/\(loggedUserUid)/chats/\(receiver.encodedFirebaseKey)").setValue(loggedUserChatUpdate)
        
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
