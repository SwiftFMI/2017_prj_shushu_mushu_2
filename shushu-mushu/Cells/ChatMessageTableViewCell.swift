//
//  ChatMessageTableViewCell.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 22.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

final class ChatMessageTableViewCell: ParentChatMessageTableViewCell {
    
    static let id = "ChatMessageTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()

        messageLabel.textColor = .black
        messageContainerView.backgroundColor = .lightGrey
    }
}
