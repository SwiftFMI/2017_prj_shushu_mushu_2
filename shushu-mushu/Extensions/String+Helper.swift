//
//  String+Helper.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 22.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import Foundation

extension String {
    
    func combineWithEmailToCreateChatId(email: String) -> String{
        return email < self ? "\(email)+\(self)" : "\(self)+\(email)"
    }
    
    mutating func encodeChatId() {
        self = self.replacingOccurrences(of: ".", with: "%2E")
    }
}
