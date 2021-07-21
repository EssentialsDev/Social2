//
//  ViewController.swift
//  Social2
//
//  Created by Kasey Schlaudt on 8/8/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            self.performSegue(withIdentifier: "toFeed", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUser(userUid: String) {
        if let imageData = self.userImgView.image!.jpegData(compressionQuality: 0.2) {
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            Storage.storage().reference().child(imgUid).putData(imageData, metadata: metaData) { (metadata, error) in
                
                let downloadURL = metadata?.downloadURL()?.absoluteString
                
                let userData = [
                    "username": self.usernameField.text!,
                    "userImg": downloadURL!
                    ] as [String : Any]
                
                Database.database().reference().child("users").child(userUid).setValue(userData)
                self.performSegue(withIdentifier: "toFeed", sender: nil)
            }
        }
    }

    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil && !(self.usernameField.text?.isEmpty)! {
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        self.setupUser(userUid: (user?.uid)!)
                        KeychainWrapper.standard.set((user?.uid)!, forKey: "uid")
                    }
                } else {
                    if let userID = user?.uid {
                        KeychainWrapper.standard.set((userID), forKey: "uid")
                        self.performSegue(withIdentifier: "toFeed", sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func getPhoto (_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage) as? UIImage {
            userImgView.image = image
        } else {
            print("image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
