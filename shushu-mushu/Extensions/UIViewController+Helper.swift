//
//  UIViewController+Helper.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 21.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

extension UIViewController {
    func pushEditProfileVC() {
        guard let editProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewControllerId") as? EditProfileViewController else {
            return
        }
        
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
}
