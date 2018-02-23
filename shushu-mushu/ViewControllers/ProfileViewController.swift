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
                UserManager.shared.isFacebookLogin = false
                
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
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let photo = dictionary["profileImageUrl"] as? String
                    if photo != nil {
                        let url = URL(string: photo!)
                        let data = try? Data(contentsOf: url!)
                        self.profileImage.image = UIImage(data: data!)
                    }
                    self.userName.text = currentUser.displayName
                    if currentUser.displayName == nil {
                    self.userName.text = dictionary["name"] as? String
                    }
                    self.userEmail.text = dictionary["email"] as? String
                }
            }, withCancel: nil)

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
