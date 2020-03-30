//
//  messageTableViewCell.swift
//  Recipe House
//
//  Created by Ajay Vandra on 3/6/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit

class messageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userLogo: UIImageView!
    @IBOutlet weak var background: UIView!
    override func awakeFromNib() {

        userLogo.layer.cornerRadius = (userLogo.frame.size.width)/2
        background.layer.cornerRadius = 10
        userLogo.clipsToBounds = true
        userLogo.layer.borderWidth = 3.0
        userLogo.layer.borderColor = UIColor.white.cgColor
        super.awakeFromNib()
        // Initialization code
    }    
}
