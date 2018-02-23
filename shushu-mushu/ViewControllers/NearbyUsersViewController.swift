//
//  NearbyUsersViewController.swift
//  shushu-mushu
//
//  Created by Natali Arabdziyska on 22.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit
import MultipeerConnectivity

final class NearbyUsersViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource, MPCManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var mpcManager: MPCManager? {
        return UserManager.shared.mpcManager
    }
    
    let cellId = "cellId"
    var isAdvertising = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        mpcManager?.delegate = self
        mpcManager?.browser.startBrowsingForPeers()
        mpcManager?.advertiser.startAdvertisingPeer()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mpcManager?.foundPeers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.textLabel?.text = mpcManager?.foundPeers[indexPath.row].displayName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let manager = mpcManager else {
            return
        }
        
        let selectedPeer = manager.foundPeers[indexPath.row]
        
        manager.browser.invitePeer(selectedPeer, to: manager.session, withContext: nil, timeout: 20)
    }
    
    func foundPeer() {
        tableView.reloadData()
    }
    
    func lostPeer() {
        tableView.reloadData()
    }
    
    func invitationWasReceived(fromPeer: String) {
        guard let manager = mpcManager else {
            return
        }
        
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to chat with you.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            manager.invitationHandler(true, manager.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            manager.invitationHandler(false, manager.session)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { [weak self] () -> Void in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        OperationQueue.main.addOperation { [weak self] () -> Void in
            self?.presentChatViewController(userEmail: peerID.displayName)
        }
    }
    
    @IBAction func startStopAdvertising(_ sender: Any) {
        let actionSheet = UIAlertController(title: "", message: "Change Visibility", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        var actionTitle: String
        if isAdvertising == true {
            actionTitle = "Make me invisible to others"
        }
        else{
            actionTitle = "Make me visible to others"
        }
        
        let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default) { [weak self] (alertAction) -> Void in
            guard let weakSelf = self else {
                return
            }
            
            if weakSelf.isAdvertising == true {
                weakSelf.mpcManager?.advertiser.stopAdvertisingPeer()
            }
            else{
                weakSelf.mpcManager?.advertiser.startAdvertisingPeer()
            }
            
            weakSelf.isAdvertising = !weakSelf.isAdvertising
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(visibilityAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}
