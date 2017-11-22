//
//  CommentsVC.swift
//  Social2
//
//  Created by Kasey Schlaudt on 9/13/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UITableViewController {
    
    var post: Post!
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toCommentPost"?:
            let destination = segue.destination as! CommentPostVC
            destination.passedPostId = self.post.postKey
        default:
            return
        }
    }
    
    func getComments() {
        Database.database().reference().child("textPosts").child(post.postKey).child("comments").observeSingleEvent(of: .value) { (snapshot) in
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { return UITableViewCell() }
        cell.configCell(post: posts[indexPath.row])
        return cell
    }
    
    @IBAction func goToComment(_ sender: AnyObject) {
        performSegue(withIdentifier: "toCommentPost", sender: nil)
    }
}
