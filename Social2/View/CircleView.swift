//
//  CircleView.swift
//  Social2
//
//  Created by Kasey Schlaudt on 9/9/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width/2
    }

}
