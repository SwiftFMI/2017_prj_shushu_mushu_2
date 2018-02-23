//
//  ChatMessageTableViewCell.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 22.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

final class ChatMessageTableViewCell: UITableViewCell {
    
    static let id = "ChatMessageTableViewCell"
    
    @IBOutlet private weak var messageContainerView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageContainerView.layer.cornerRadius = 4
        messageLabel.textColor = .black
        messageContainerView.backgroundColor = .lightGrey
    }
    
    func setupForChatMessage(_ chatMessage: ChatMessage) {
        messageLabel.text = chatMessage.text
    }
}
