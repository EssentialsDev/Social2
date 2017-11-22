//
//  ShareSomethingCell.swift
//  Social2
//
//  Created by Kasey Schlaudt on 8/23/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import UIKit
import Firebase

class ShareSomethingCell: UITableViewCell {
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(userImgUrl: String) {
        let httpsReference = Storage.storage().reference(forURL: userImgUrl)
        
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.userImgView.image = image
            }
        }
    }

}
