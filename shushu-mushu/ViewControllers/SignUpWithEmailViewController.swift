//
//  SignUpWithEmailViewController.swift
//  shushu-mushu
//
//  Created by Natali Arabdziyska on 14.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

final class SignUpWithEmailViewController: LoginParentViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var ref = Database.database().reference()
    
    @IBAction func signUpWithEmail(_ sender: UIButton) {
        guard emailField.text?.isEmpty == false && passwordField.text?.isEmpty == false else {
            showErrorAlert(message: "Please enter your email and password")
            return
        }
        
        hideKeyboard()
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { [weak self] (user, error) in
            guard let weakSelf = self else {
                return
            }
            
            if let unwrappedError = error {
                weakSelf.showErrorAlert(message: unwrappedError.localizedDescription)
                
            } else {
                let ref = Database.database().reference()
                let usersReference = ref.child("users").child((Auth.auth().currentUser?.uid)!)
                var userName: String!
                if Auth.auth().currentUser?.displayName != nil {
                    userName = Auth.auth().currentUser?.displayName
                } else {
                    var token = weakSelf.emailField.text?.components(separatedBy: "@")
                    userName = token?[0]
                }
                
                let values: [String : Any] = ["email": weakSelf.emailField.text!, "name": userName]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print(err)
                        return
                    }
                })
                
                weakSelf.switchToHome()
            }
        }
    }
}
