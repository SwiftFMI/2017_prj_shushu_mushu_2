//
//  ParentChatMessageTableViewCell.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 23.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

class ParentChatMessageTableViewCell: UITableViewCell {
    
    @IBOutlet private(set) weak var messageContainerView: UIView!
    @IBOutlet private(set) weak var messageLabel: UILabel!
    @IBOutlet private(set) weak var messageImageView: UIImageView!
    
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageContainerView.layer.cornerRadius = 4
        messageContainerView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messageLabel.text = ""
        messageImageView.image = nil
    }
    
    func setupForChatMessage(_ chatMessage: ChatMessage) {
        if let unwrappedText = chatMessage.text {
            messageLabel.text = unwrappedText
            imageViewHeightConstraint.isActive = false
            
        } else if let unwrappedImageUrl = chatMessage.imageUrl {
            messageImageView.loadImageUsingCacheWithUrlString(unwrappedImageUrl)
            imageViewHeightConstraint.isActive = true
        }
    }
}
