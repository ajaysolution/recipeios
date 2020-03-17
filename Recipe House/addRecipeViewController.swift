//
//  addRecipeViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 3/16/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import PINRemoteImage
import DropDown

class addRecipeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var levelDrop = DropDown()
   //var addIngreArray = [AddIngredient]()
    var addIngredientArray = [Ingredient]()
    var addStepArray = [Step]()
    var sections = ["Ingredient","Steps"]

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeNameTxtField: UITextField!
    @IBOutlet weak var recipeTypeTxtField: UITextField!
    @IBOutlet weak var recipeHourTxtField: UITextField!
    @IBOutlet weak var recipeMinuteTxtField: UITextField!
    @IBOutlet weak var recipePeopleTxtField: UITextField!
    @IBOutlet weak var ingredientTxtField: UITextField!
    @IBOutlet weak var stepTxtField: UITextField!
    @IBOutlet weak var levelButtonOutlet: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
            super.viewDidLoad()

        tableView.register(UINib(nibName: "ingredientTableViewCell", bundle: nil), forCellReuseIdentifier: "ingredient")
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section] == "Ingredient"{
        return addIngredientArray.count
        }
        else{
            return addStepArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredient", for: indexPath) as! ingredientTableViewCell
        if sections[indexPath.section] == "Ingredient"{
            cell.instructionLabel.text = addIngredientArray[indexPath.row].ingredientName
        }
        if sections[indexPath.section] == "Steps"{
            cell.instructionLabel.text = addStepArray[indexPath.row].stepName
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    @IBAction func addIngredientButton(_ sender: UIButton) {
        let ingredientData = Ingredient()
        if ingredientTxtField.text!.isEmpty{
            let alert = UIAlertController(title: "you can't add null value", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "fill value", style: .cancel) { (action) in
                
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }else{
        ingredientData.ingredientName = ingredientTxtField.text!
        addIngredientArray.append(ingredientData)
        tableView.reloadData()
        }
//        addStatic.insert(ingredientTxtField.text!, at: addStatic.startIndex)
//        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    @IBAction func addStepButton(_ sender: UIButton) {
        let stepData = Step()
        if stepTxtField.text!.isEmpty{
            let alert = UIAlertController(title: "you can't add null value", message: "", preferredStyle: .alert)
                       let action = UIAlertAction(title: "fill value", style: .cancel) { (action) in
                           
                       }
                       alert.addAction(action)
                       present(alert, animated: true, completion: nil)
        }else{
            stepData.stepName = stepTxtField.text!
            addStepArray.append(stepData)
            tableView.reloadData()
        }
    }
    func levelDropdown(){
        levelDrop.anchorView = levelButtonOutlet
        levelDrop.dataSource = ["easy","medium","hard"]
         levelDrop.selectionAction = {  (index: Int, item: String) in
           print("Selected item: \(item) at index: \(index)")
            if item == "easy"{
                print("easy")
                self.levelButtonOutlet.titleLabel?.text = "easy"
            }
            else if item == "medium"{
                print("medium")
                self.levelButtonOutlet.titleLabel?.text = "medium"
            }
            else{
                self.levelButtonOutlet.titleLabel?.text = "hard"
                print("hard")
            }
         }

         levelDrop.bottomOffset = CGPoint(x: -50, y: levelButtonOutlet.bounds.height)
         levelDrop.width = 100
    }
    @IBAction func levelDropdown(_ sender: UIButton) {
        levelDropdown()
        levelDrop.show()
    }
    @IBAction func selectRecipeImage(_ sender: UIButton) {
    }
    
}

