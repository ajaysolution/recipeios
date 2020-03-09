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

        super.awakeFromNib()
        // Initialization code
    }    
}
