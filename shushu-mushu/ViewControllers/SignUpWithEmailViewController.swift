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

class SignUpWithEmailViewController: LoginParentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var ref = Database.database().reference()
    
    @IBAction func signUpWithEmail(_ sender: UIButton) {
        if emailField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            hideKeyboard()
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                
                if error == nil {
                    let ref = Database.database().reference()
                    let usersReference = ref.child("users").child((Auth.auth().currentUser?.uid)!)
                    var userName: String!
                    if Auth.auth().currentUser?.displayName != nil {
                        userName = Auth.auth().currentUser?.displayName
                    }
                    else {
                        let del = "@"
                        var token = self.emailField.text?.components(separatedBy: del)
                        userName = token?[0]
                    }
                    let values = ["email": self.emailField.text!, "name": userName]
                    usersReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print(err)
                            return
                        }
                    })
                    
                    self.switchToHome()
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                }
        }
    }

}
