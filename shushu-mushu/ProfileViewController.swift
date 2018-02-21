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

class ProfileViewController: UIViewController {


    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBAction func signOut(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInView")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = Auth.auth().currentUser {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["profileImageUrl"] as? String
                    let photo = self.navigationItem.title
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
            let signIn = SignInViewController()
            if signIn.isFacebookLogin == true {
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
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
