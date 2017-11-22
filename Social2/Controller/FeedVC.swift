//
//  FeedVC.swift
//  Social2
//
//  Created by Kasey Schlaudt on 8/16/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UITableViewController {
    
    var currentUserImageUrl: String!
    var posts = [Post]()
    var selectedPost: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersData()
        getPosts()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toComments"?:
            let destination = segue.destination as! CommentsVC
            destination.post = self.selectedPost
        default:
            return
        }
    }
    
    func getUsersData(){
      let uid = KeychainWrapper.standard.string(forKey: "uid")
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let postDict = snapshot.value as? [String : AnyObject] {
                self.currentUserImageUrl = postDict["userImg"] as! String
                self.tableView.reloadData()
            }
        }
    }
    
    func getPosts() {
        Database.database().reference().child("textPosts").observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.posts.removeAll()
            for data in snapshot.reversed() {
                guard let postDict = data.value as? Dictionary<String, AnyObject> else { return }
                let post = Post(postKey: data.key, postData: postDict)
                self.posts.append(post)
            }
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ShareSomethingCell") as? ShareSomethingCell {
                if currentUserImageUrl != nil {
                    cell.configCell(userImgUrl: currentUserImageUrl)
                    cell.shareBtn.addTarget(self, action: #selector(toCreatePost), for: .touchUpInside)
                }
                return cell
            }
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell else { return UITableViewCell() }
        cell.commentBtn.addTarget(self, action: #selector(toComments(_:)), for: .touchUpInside)
        cell.configCell(post: posts[indexPath.row-1])
        return cell
    }

    @objc func signOut (_ sender: AnyObject) {
        KeychainWrapper.standard.removeObject(forKey: "uid")
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        dismiss(animated: true, completion: nil)
    }

    @objc func toCreatePost (_ sender: AnyObject) {
        performSegue(withIdentifier: "toCreatePost", sender: nil)
    }
    
    @objc func toComments(_ sender: AnyObject) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath: IndexPath? =  tableView.indexPathForRow(at: buttonPosition)
        
        selectedPost = posts[(indexPath?.row)!]
        performSegue(withIdentifier: "toComments", sender: nil)
        
    }
}














