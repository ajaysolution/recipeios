//
//  RecipeTableViewCell.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/26/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var RecipeTypeLabel: UILabel!
    var counts = 0
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
     @IBOutlet weak var timeLabel: UILabel!
     @IBOutlet weak var levelLabel: UILabel!
     @IBOutlet weak var peopleLabel: UILabel!
    
    @IBOutlet weak var favoriteButtonLabel: UIButton!
    @IBOutlet weak var count: UILabel!
    
    @IBAction func commentButton(_ sender: UIButton) {
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        if counts == 0{
            favoriteButtonLabel.isSelected = true
             favoriteButtonLabel.setImage(UIImage(named: "redHeart"), for: .selected)
            counts = 1
        }else{
            favoriteButtonLabel.isSelected = false
            counts = 0
        }
    }
}
