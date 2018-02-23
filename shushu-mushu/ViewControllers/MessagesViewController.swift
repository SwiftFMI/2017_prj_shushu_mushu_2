//
//  MessagesViewController.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 21.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit
import Firebase

final class MessagesViewController: ParentViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var dataArray: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = ChatTableViewCell.height
        tableView.register(UINib(nibName: "\(ChatTableViewCell.self)", bundle: nil), forCellReuseIdentifier: ChatTableViewCell.id)
        
        navigationItem.title = "Messages"
        
        fetchChats()
    }
    
    private func fetchChats() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("users/\(uid)/chats").observe(.value) { [weak self] (snapshot) in
            guard let weakSelf = self else {
                return
            }
            
            guard let responseDictionary = snapshot.value as? [String: [String: Any]] else {
                return
            }
            
            weakSelf.dataArray = responseDictionary
                .flatMap({ (key, value) -> Chat? in Chat(dictionary: value) })
                .sorted(by: { $0.lastMessageTimestamp > $1.lastMessageTimestamp })
            
            weakSelf.tableView.reloadData()
        }
    }
}

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chatCell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.id) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        
        chatCell.setupForChat(dataArray[indexPath.row])
        return chatCell
    }
}

extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presentChatViewController(userEmail: dataArray[indexPath.row].partner)
    }
}
