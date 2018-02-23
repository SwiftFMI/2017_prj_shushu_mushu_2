//
//  UIViewController+Helper.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 21.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        let firstColor = UIColor(red:0.83, green:0.33, blue:0.00, alpha:1.0).cgColor
        let secondColor = UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.0).cgColor
        gradientLayer.colors = [firstColor,secondColor,firstColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    func makeNavigationBarTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    func pushEditProfileVC() {
        guard let editProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewControllerId") as? EditProfileViewController else {
            return
        }
        
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    func switchToHome() {
        guard let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as? UITabBarController else {
            return
        }
        
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = tabBarController
    }
    
    func switchToSignIn() {
        guard let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInView") as? SignInViewController else {
            return
        }
        
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = signInVC
    }
    
    func presentChatViewController(userEmail: String) {
        guard let chatNavigation = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatNavigationControllerId") as? UINavigationController, let chatVC = chatNavigation.viewControllers.first as? ChatViewController else {
            return
        }
        
        chatVC.email = userEmail
        present(chatNavigation, animated: true, completion: nil)
    }
}
