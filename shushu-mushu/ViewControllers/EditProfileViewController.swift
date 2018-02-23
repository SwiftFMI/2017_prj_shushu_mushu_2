//
//  EditProfileViewController.swift
//  shushu-mushu
//
//  Created by Natali Arabdziyska on 16.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

final class EditProfileViewController: ParentViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Change picture
    @IBOutlet weak var changedPhoto: UIImageView!
    
    private var didChangePhoto = false
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Take photo with camera
    @IBAction func takePhoto(_ sender: UIButton) {
        let imagePickerForCamera = UIImagePickerController()
        imagePickerForCamera.delegate = self
        imagePickerForCamera.sourceType = .camera
        present(imagePickerForCamera, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : Any]!){
        dismiss(animated: true)
        changedPhoto.image = image
        didChangePhoto = true
    }
    
    let storage = Storage.storage()
    
    func uploadImagePic(img1 :UIImage){
        guard let data = UIImageJPEGRepresentation(img1, 0.8) else {
            return
        }
        
        // set upload path
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        storageRef.putData(data, metadata: metaData) { [weak self] (metadata, error) in
            guard let weakSelf = self else {
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                weakSelf.registerUserIntoDatabaseWithUID((Auth.auth().currentUser?.uid)!, profileImageUrl: profileImageUrl)
            }
        }
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, profileImageUrl: String) {
        var values = [
            "profileImageUrl": profileImageUrl
        ]
        
        if let newName = changedName.text, !newName.isEmpty {
            values["name"] = newName
        }
        
        Database.database().reference().root.child("users/\(uid)").updateChildValues(values) { [weak self] (error, response) in
            guard let weakSelf = self else {
                return
            }
            
            if let unwrappedError = error {
                weakSelf.showErrorAlert(message: unwrappedError.localizedDescription)
            } else {
                weakSelf.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //Change data for the person
    @IBOutlet weak var changedName: UITextField!
    @IBOutlet weak var changedEmail: UITextField!
    let profile = ProfileViewController()
    
    @IBAction func saveChanges(_ sender: UIButton) {
        if didChangePhoto, let unwrappedImage = changedPhoto.image {
            uploadImagePic(img1: unwrappedImage)
            
        } else if let uid = Auth.auth().currentUser?.uid, let newName = changedName.text, !newName.isEmpty {
            Database.database().reference().root.child("users/\(uid)").updateChildValues(["name": newName])
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Edit profile"
        
        //load Picture
        let user = Auth.auth().currentUser
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let weakSelf = self, let dictionary = snapshot.value as? [String: AnyObject], let photo = dictionary["profileImageUrl"] as? String, let url = URL(string: photo), let data = try? Data(contentsOf: url) else {
                return
            }
            
            weakSelf.changedPhoto.image = UIImage(data: data)
        }, withCancel: nil)
        
        if UserManager.shared.isFacebookLogin {
            let photo = user?.photoURL?.absoluteString
            let url = URL(string: photo!)
            let data = try? Data(contentsOf: url!)
            self.changedPhoto.image = UIImage(data: data!)
        } else {
            if user?.photoURL?.absoluteString == nil {
                self.changedPhoto.image = UIImage(named: "default-user-image")
            }
        }
        // Set default name and email
        changedEmail.isEnabled = false
        changedEmail.text = user?.email
        changedName.text = user?.displayName
        if user?.displayName == nil {
            let del = "@"
            var token = user?.email?.components(separatedBy: del)
            changedName.text = token?[0]
        }
        changedPhoto.layer.cornerRadius = changedPhoto.frame.size.width / 2
        changedPhoto.clipsToBounds = true
    }
}
