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

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Change picture
    @IBOutlet weak var changedPhoto: UIImageView!
    var imagePicker = UIImagePickerController()
    var didTapUpload = false
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        didTapUpload = true
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Take photo with camera
    var imagePickerForCamera: UIImagePickerController!
    
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePickerForCamera =  UIImagePickerController()
        imagePickerForCamera.delegate = self
        imagePickerForCamera.sourceType = .camera
        present(imagePickerForCamera, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : Any]!){
        dismiss(animated: true)
        changedPhoto.image = image
    }
    
    let storage = Storage.storage()
    
    func uploadImagePic(img1 :UIImage){
        let data = UIImageJPEGRepresentation(img1, 0.8)! as NSData
        // set upload path
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        if let profileImage = self.changedPhoto.image, let _ = UIImageJPEGRepresentation(profileImage, 0.1) {
            storageRef.putData(data as Data, metadata: metaData) { [weak self] (metadata, error) in
                guard let weakSelf = self else {
                    return
                }
                
                if let error = error {
                    print(error.localizedDescription)
                } else if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    let values = ["email": Auth.auth().currentUser?.email, "profileImageUrl": profileImageUrl]
                    weakSelf.registerUserIntoDatabaseWithUID((Auth.auth().currentUser?.uid)!, values: values as [String : AnyObject])
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://shushu-mushu.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { [weak self] (err, ref) in
            guard let weakSelf = self else {
                return
            }
            
            if let err = err {
                print(err)
            } else {
                weakSelf.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    //Change data for the person
    @IBOutlet weak var changedName: UITextField!
    @IBOutlet weak var changedEmail: UITextField!
    let profile = ProfileViewController()
    
    @IBAction func saveChanges(_ sender: UIButton) {
        if didTapUpload == true {
            uploadImagePic(img1: changedPhoto.image!)
        }
        let uid = Auth.auth().currentUser?.uid
        let values = ["email": self.changedEmail.text, "name":self.changedName.text]
        _ = Database.database().reference().root.child("users").child(uid!).updateChildValues(values as Any as! [AnyHashable : Any])
        Auth.auth().currentUser?.updateEmail(to: self.changedEmail.text!)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Edit profile"
        
        //load Picture
        let user = Auth.auth().currentUser
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let photo = dictionary["profileImageUrl"] as? String
                if photo != nil {
                    let url = URL(string: photo!)
                    let data = try? Data(contentsOf: url!)
                    self.changedPhoto.image = UIImage(data: data!)
                }
            }
        }, withCancel: nil)
        let signIn = SignInViewController()
        if signIn.isFacebookLogin == true {
            let photo = user?.photoURL?.absoluteString
            let url = URL(string: photo!)
            let data = try? Data(contentsOf: url!)
            self.changedPhoto.image = UIImage(data: data!)
        }
        else{
            if user?.photoURL?.absoluteString == nil {
                self.changedPhoto.image = UIImage(named: "default-user-image")
            }
        }
        // Set default name and email
        changedEmail.text = user?.email
        changedName.text = user?.displayName
        if user?.displayName == nil {
            let del = "@"
            var token = user?.email?.components(separatedBy: del)
            changedName.text = token?[0]
        }
        imagePicker.delegate = self
        changedPhoto.layer.cornerRadius = changedPhoto.frame.size.width / 2
        changedPhoto.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
