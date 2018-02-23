//
//  AllUsersViewController.swift
//  shushu-mushu
//
//  Created by Natali Arabdziyska on 20.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit
import Firebase

final class AllUsersViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { [weak self] (snapshot) in
            guard let weakSelf = self, let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = snapshot.key
            weakSelf.users.append(user)
            
            //this will crash because of background thread, so lets use dispatch_async to fix
            DispatchQueue.main.async(execute: { [weak self] in
                self?.tableView.reloadData()
            })
            // user.name = dictionary["name"]
        }, withCancel: nil)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        } else {
            cell.profileImageView.image = UIImage(named: "default-user-image")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = users[indexPath.row]
        
        guard let email = user.email else {
            return
        }
        
        presentChatViewController(userEmail: email)
    }
}
