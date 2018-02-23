//
//  LoggedUserChatMessageTableViewCell.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 23.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

final class LoggedUserChatMessageTableViewCell: UITableViewCell {

    static let id = "LoggedUserChatMessageTableViewCell"
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageLabel.textColor = .white
        messageContainerView.backgroundColor = .orange
        messageContainerView.layer.cornerRadius = 4
    }
    
    func setupForChatMessage(_ chatMessage: ChatMessage) {
        messageLabel.text = chatMessage.text
    }
}
