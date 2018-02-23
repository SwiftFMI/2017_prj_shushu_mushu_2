//
//  ChatTableViewCell.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 23.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

final class ChatTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 40
    static let id = "ChatTableViewCell"
    
    @IBOutlet private weak var chatNameLabel: UILabel!
    
    func setupForChat(_ chat: Chat) {
        chatNameLabel.text = chat.partner
    }
}
