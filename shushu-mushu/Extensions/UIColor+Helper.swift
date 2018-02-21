//
//  UIColor+Helper.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 21.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

extension UIColor {
    static let orange = UIColor(rgb: 0xF39C12)
    static let darkOrange = UIColor(rgb: 0xD35400)
    static let darkRed = UIColor(rgb: 0xC0392B)
    static let lightGrey = UIColor(rgb: 0xBDC3C7)
    static let darkGrey = UIColor(rgb: 0x7F8C8D)
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
