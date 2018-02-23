//
//  SignInViewController.swift
//  shushu-mushu
//
//  Created by Natali Arabdziyska on 14.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

final class SignInViewController: LoginParentViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            switchToHome()
        } else {
            makeNavigationBarTransparent()
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        guard usernameTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false else {
            showErrorAlert(message: "Please enter an email and password.")
            return
        }
        
        hideKeyboard()
        
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { [weak self] (user, error) in
            guard let weakSelf = self else {
                return
            }
            
            if error == nil {
                weakSelf.switchToHome()
            } else {
                weakSelf.showErrorAlert(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { [weak self] (user, error) in
                guard let weakSelf = self else {
                    return
                }
                
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    weakSelf.showErrorAlert(message: error.localizedDescription)
                    return
                }
                
                UserManager.shared.isFacebookLogin = true
                
                // Present the main view
                weakSelf.switchToHome()
            })
        }
    }
}
