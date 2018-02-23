//
//  User.swift
//  shushu-mushu
//
//  Created by Natali Arabdziyska on 20.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

final class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
