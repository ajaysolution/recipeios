//
//  ingredientTableViewCell.swift
//  Recipe House
//
//  Created by Ajay Vandra on 3/16/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit

class ingredientTableViewCell: UITableViewCell {
    //MARK: - outlet
    @IBOutlet weak var addRecipeTextCell: UITextField!
    //MARK: - 
    override func awakeFromNib() {
        super.awakeFromNib()
        addRecipeTextCell.borderStyle = UITextField.BorderStyle.none
    }
}
