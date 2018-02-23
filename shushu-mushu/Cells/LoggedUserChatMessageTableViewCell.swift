//
//  LoggedUserChatMessageTableViewCell.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 23.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

final class LoggedUserChatMessageTableViewCell: ParentChatMessageTableViewCell {

    static let id = "LoggedUserChatMessageTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageLabel.textColor = .white
        messageContainerView.backgroundColor = .orange
    }
}
