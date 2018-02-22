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
    
    @IBOutlet private  var messageContainerLeadingSpace: NSLayoutConstraint!
    @IBOutlet private  var messageContainerTrailingSpace: NSLayoutConstraint!
    @IBOutlet private  var messageContainerLoggedUserLeadingSpace: NSLayoutConstraint!
    @IBOutlet private  var messageContainerLoggedUserTrailingSpace: NSLayoutConstraint!
    
    private var loggedUserConstraints: [NSLayoutConstraint] {
        return [messageContainerLoggedUserLeadingSpace, messageContainerLoggedUserTrailingSpace]
    }
    
    private var defaultConstraints: [NSLayoutConstraint] {
        return [messageContainerLeadingSpace, messageContainerTrailingSpace]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageContainerView.layer.cornerRadius = 4
    }
    
    func setupForChatMessage(_ chatMessage: ChatMessage) {
        if chatMessage.isFromLoggedUser {
            NSLayoutConstraint.deactivate(defaultConstraints)
            NSLayoutConstraint.activate(loggedUserConstraints)
            
            messageLabel.textColor = .white
            messageContainerView.backgroundColor = .orange
            
        } else {
            NSLayoutConstraint.deactivate(loggedUserConstraints)
            NSLayoutConstraint.activate(defaultConstraints)
            
            messageLabel.textColor = .black
            messageContainerView.backgroundColor = .lightGrey
        }
        
        messageLabel.text = chatMessage.text
    }
}
