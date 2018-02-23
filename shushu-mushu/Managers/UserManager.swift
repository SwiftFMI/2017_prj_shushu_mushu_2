//
//  UserManager.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 23.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import Foundation
import Firebase

final class UserManager {
    static let shared = UserManager()
    
    var isFacebookLogin = false
    private(set) var mpcManager: MPCManager?
    
    func login() {
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        
        mpcManager = MPCManager(email: email)
    }
    
    func logout() {
        isFacebookLogin = false
    }
}
