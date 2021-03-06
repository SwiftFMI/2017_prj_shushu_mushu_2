//
//  SearchUsersViewController.swift
//  shushu-mushu
//
//  Created by Natali Arabdziyska on 21.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit
import Firebase

final class SearchUsersViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive = false
    var users = [User]()
    var filtered:[User] = []
    let cellId = "cellId"
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { [weak self] (snapshot) in
            guard let weakSelf = self else {
                return
            }
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                if Auth.auth().currentUser?.email != user.email {
                    user.id = snapshot.key
                    weakSelf.users.append(user)
                    
                    //this will crash because of background thread, so lets use dispatch_async to fix
                    DispatchQueue.main.async(execute: { [weak self] in
                        self?.tableView.reloadData()
                    })
                    // user.name = dictionary["name"]
                }
            }
            
        }, withCancel: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = !searchText.isEmpty
        
        if searchText.isEmpty {
            filtered = []
        } else {
            filtered = users.filter({ (text) -> Bool in
                let tmp = text.email as NSString?
                let range = tmp?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let tmp2 = text.name as NSString?
                let range2 = tmp2?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range!.location != NSNotFound || range2!.location != NSNotFound
            })
        }
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filtered.count : users.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = userAtIndexPath(indexPath)
        
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
        
        guard let email = userAtIndexPath(indexPath).email else {
            return
        }
        
        presentChatViewController(userEmail: email)
    }
    
    private func userAtIndexPath(_ indexPath: IndexPath) -> User {
        return searchActive ? filtered[indexPath.row] : users[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
}
