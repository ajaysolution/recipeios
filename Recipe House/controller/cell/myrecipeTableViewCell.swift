//
//  myrecipeTableViewCell.swift
//  Recipe House
//
//  Created by Ajay Vandra on 3/25/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit

class myrecipeTableViewCell: UITableViewCell {
    //MARK: - outlet
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var RecipeTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var commentButtonLabel: UIButton!
    @IBOutlet weak var favoriteButtonLabel: UIButton!
    @IBOutlet weak var deleteButtonLabel: UIButton!
    @IBOutlet weak var count: UILabel!
    var recipeId : Int?
    //MARK: - IBAction
    @IBAction func commentButton(_ sender: UIButton) {
    }
    @IBAction func favoriteButton(_ sender: UIButton) {
    }
    @IBAction func deleteButton(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
