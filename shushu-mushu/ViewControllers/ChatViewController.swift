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
    @IBOutlet private weak var inputContainerView: UIView!
    @IBOutlet private weak var uploadImageButton: UIBarButtonItem!
    
    @IBOutlet weak var inputContainerBottomConstraint: NSLayoutConstraint!
    
    private var sizingCell: ChatMessageTableViewCell?
    private var dataArray: [ChatMessage] = []
    private var chatId = ""
    
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "\(ChatMessageTableViewCell.self)", bundle: nil), forCellReuseIdentifier: ChatMessageTableViewCell.id)
        tableView.register(UINib(nibName: "\(LoggedUserChatMessageTableViewCell.self)", bundle: nil), forCellReuseIdentifier: LoggedUserChatMessageTableViewCell.id)
        sizingCell = tableView.dequeueReusableCell(withIdentifier: ChatMessageTableViewCell.id) as? ChatMessageTableViewCell
        
        navigationItem.title = "Chat"
        uploadImageButton.title = "Upload image"
        backButton.title = "Close"
        sendButton.setTitle("Send", for: .normal)

        updateTableViewBottomInset()
        generateChatId()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
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
    }
    
    private func clearInputText() {
        textView.text = ""
    }
    
    private func updateTableViewBottomInset() {
        let bottomInset = inputContainerView.frame.size.height + inputContainerBottomConstraint.constant
        
        tableView.contentInset.bottom = bottomInset
        tableView.scrollIndicatorInsets.bottom = bottomInset
    }
    
    private func fetchChatMessages() {
        Database.database().reference().child("chats/\(chatId.encodedFirebaseKey)/messages").observe(.value) { [weak self] (snapshot) in
            guard let weakSelf = self else {
                return
            }
            
            guard let response = snapshot.value as? [String: [String: Any]] else {
                return
            }
            
            weakSelf.dataArray = response
                .flatMap({ (_, value) -> ChatMessage? in ChatMessage(dictionary: value) })
                .sorted(by: { $0.timestamp < $1.timestamp })
            
            weakSelf.tableView.reloadData()
        }
    }
    
    @IBAction func uploadImageTapped(_ sender: Any) {
        hideKeyboard()
        
        let actionSheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openGalleryAction = UIAlertAction(
            title: "Gallery",
            style: .default,
            handler: { [weak self] (action) in
                guard let weakSelf = self else {
                    return
                }
                
                let pickerController = UIImagePickerController()
                pickerController.sourceType = .photoLibrary
                pickerController.delegate = weakSelf
                weakSelf.present(pickerController, animated: true, completion: nil)
            }
        )
        actionSheetVC.addAction(openGalleryAction)
        
        let openCamera = UIAlertAction(
            title: "Camera",
            style: .default,
            handler: { [weak self] (action) in
                guard let weakSelf = self else {
                    return
                }
                
                let pickerController = UIImagePickerController()
                pickerController.sourceType = .camera
                pickerController.delegate = weakSelf
                weakSelf.present(pickerController, animated: true, completion: nil)
            }
        )
        actionSheetVC.addAction(openCamera)
        
        actionSheetVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheetVC, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard !textView.text.isEmpty else {
            return
        }
        
        Api.sendChatMessageWith(text: textView.text, receiver: email, inChat: chatId)
        clearInputText()
        hideKeyboard()
    }
    
    private func setInputViewBottomConstraint(_ value: CGFloat, animated: Bool) {
        inputContainerBottomConstraint.constant = value
        updateTableViewBottomInset()
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        } else {
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - Notifications
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        setInputViewBottomConstraint(keyboardSize.size.height, animated: true)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        setInputViewBottomConstraint(0, animated: true)
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeightForIndexPath(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeightForIndexPath(indexPath)
    }
    
    private func calculateHeightForIndexPath(_ indexPath: IndexPath) -> CGFloat {
        let message = dataArray[indexPath.row]
        
        if message.rowHeight == 0 {
            guard let sizingCellUnwrapped = sizingCell else {
                return 0
            }
            
            sizingCellUnwrapped.prepareForReuse()
            sizingCellUnwrapped.setupForChatMessage(message)
            message.rowHeight = sizingCellUnwrapped.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        }
        
        return message.rowHeight
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessage = dataArray[indexPath.row]
        
        if chatMessage.isFromLoggedUser {
            guard let chatMessageCell = tableView.dequeueReusableCell(withIdentifier: LoggedUserChatMessageTableViewCell.id) as? LoggedUserChatMessageTableViewCell else {
                return UITableViewCell()
            }
            
            chatMessageCell.setupForChatMessage(chatMessage)
            return chatMessageCell
            
        } else {
            guard let chatMessageCell = tableView.dequeueReusableCell(withIdentifier: ChatMessageTableViewCell.id) as? ChatMessageTableViewCell else {
                return UITableViewCell()
            }
            
            chatMessageCell.setupForChatMessage(chatMessage)
            return chatMessageCell
        }
    }
}

extension ChatViewController: UINavigationControllerDelegate {
    
}

extension ChatViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        Api.sendChatMessageWith(image: pickedImage, receiver: email, inChat: chatId)
        dismiss(animated: true, completion: nil)
    }
}

