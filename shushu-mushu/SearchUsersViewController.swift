//
//  SearchUsersViewController.swift
//  shushu-mushu
//
//  Created by Natali Arabdziyska on 21.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit
import Firebase

class SearchUsersViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive = false
    var users = [User]()
    var filtered:[User] = []
    let cellId = "cellId"
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                if Auth.auth().currentUser?.email != user.email {
                    user.id = snapshot.key
                    self.users.append(user)
                    
                    //this will crash because of background thread, so lets use dispatch_async to fix
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
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
        if(searchActive){
            let found = filtered[indexPath.row]
            cell.textLabel?.text = found.name
            cell.detailTextLabel?.text = found.email
            if let profileImageUrl = found.profileImageUrl {
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
            else {
                cell.profileImageView.image = UIImage(named: "default-user-image")
            }
        } else {
            let user = users[indexPath.row]
            cell.textLabel?.text = user.name
            cell.detailTextLabel?.text = user.email
        }
        return cell;
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
