//
//  ProfileViewController.swift
//  shushu-mushu
//
//  Created by Natali Arabdziyska on 16.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

final class ProfileViewController: ParentViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func signOut(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                switchToSignIn()
                UserManager.shared.logout()
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        
        if let currentUser = Auth.auth().currentUser {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value) { [weak self] (snapshot) in
                guard let weakSelf = self else {
                    return
                }
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    if let photo = dictionary["profileImageUrl"] as? String {
                        weakSelf.profileImage.loadImageUsingCacheWithUrlString(photo)
                    }
                    weakSelf.userName.text = currentUser.displayName
                    if currentUser.displayName == nil {
                        weakSelf.userName.text = dictionary["name"] as? String
                    }
                    weakSelf.userEmail.text = dictionary["email"] as? String
                }
            }

            if UserManager.shared.isFacebookLogin {
                let photo = currentUser.photoURL?.absoluteString
                let url = URL(string: photo!)
                let data = try? Data(contentsOf: url!)
                self.profileImage.image = UIImage(data: data!)
            }
            else{
                if currentUser.photoURL?.absoluteString == nil {
                    self.profileImage.image = UIImage(named: "default-user-image")
                }
            }
            profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
            profileImage.clipsToBounds = true
        }
    }
}
