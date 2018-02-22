//
//  ChatViewController.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 22.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

final class ChatViewController: ParentViewController {
    
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var textView: UITextView!
    
    private var dataArray: [ChatMessage] = []
    private var chatId = ""
    
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 50
        tableView.register(UINib(nibName: "\(ChatMessageTableViewCell.self)", bundle: nil), forCellReuseIdentifier: ChatMessageTableViewCell.id)
        
        navigationItem.title = "Chat"
        backButton.title = "Back"
        sendButton.setTitle("Send", for: .normal)

        generateChatId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchChatMessages()
    }
    
    private func generateChatId() {
        guard !email.isEmpty, let loggedUserEmail = Auth.auth().currentUser?.email else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        chatId = email.combineWithEmailToCreateChatId(email: loggedUserEmail)
        chatId.encodeChatId()
    }
    
    private func clearInputText() {
        textView.text = ""
    }
    
    private func fetchChatMessages() {
        Database.database().reference().child("chats/\(chatId)/messages").observe(.value) { [weak self] (snapshot) in
            guard let weakSelf = self else {
                return
            }
            
            guard let response = snapshot.value as? [String: [String: Any]] else {
                return
            }
            
            weakSelf.dataArray = response
                .flatMap({ (_, value) -> ChatMessage? in
                    return ChatMessage(dictionary: value)
                })
                .sorted(by: { $0.timestamp < $1.timestamp })
            
            weakSelf.tableView.reloadData()
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard !textView.text.isEmpty, let loggedUserEmail = Auth.auth().currentUser?.email else {
            return
        }
        
        let message: [String: Any] = [
            "sender": loggedUserEmail,
            "text": textView.text,
            "dateCreated": ServerValue.timestamp()
        ]
        
        Database.database().reference().child("chats/\(chatId)/messages").childByAutoId().setValue(message)
        clearInputText()
    }
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chatMessageCell = tableView.dequeueReusableCell(withIdentifier: ChatMessageTableViewCell.id) as? ChatMessageTableViewCell else {
            return UITableViewCell()
        }
        
        chatMessageCell.setupForChatMessage(dataArray[indexPath.row])
        
        return chatMessageCell
    }
}

