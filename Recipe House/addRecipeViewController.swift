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

class addRecipeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var levelDrop = DropDown()
   //var addIngreArray = [AddIngredient]()
    var addIngredientArray = [Ingredient]()
    var addStepArray = [Step]()
    var arrayToString : String = ""
    var type : String = ""
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
        ingredientTxtField.text = ""
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
            print(addStepArray)
            tableView.reloadData()
            stepTxtField.text = ""
        }
    }
    func levelDropdown(){
        levelDrop.anchorView = levelButtonOutlet
        levelDrop.dataSource = ["easy","medium","hard"]
         levelDrop.selectionAction = {  (index: Int, item: String) in
           print("Selected item: \(item) at index: \(index)")
            if item == "easy"{
                self.type = "easy"
                self.levelButtonOutlet.titleLabel?.text = "easy"
            }
            else if item == "medium"{
                self.type = "medium"
                self.levelButtonOutlet.titleLabel?.text = "medium"
            }
            else{
                self.levelButtonOutlet.titleLabel?.text = "hard"
                self.type = "hard"
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
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = true
        present(image, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            recipeImageView.image = image
        }else{
            print(Error.self)
        }
        self.dismiss(animated: true, completion: nil)
    }
    func addRecipeDetail()->Bool{
        if recipeNameTxtField.text!.isEmpty{
            alert(alertTitle: "Enter recipe name", alertMessage: "nil", actionTitle: "enter recipe name")
            return false
        }
        else if recipeTypeTxtField.text!.isEmpty{
            alert(alertTitle: "Enter recipe type", alertMessage: "nil", actionTitle: "enter recipe type")
            return false
        }
        else if recipeHourTxtField.text!.isEmpty{
            alert(alertTitle: "Enter hour", alertMessage: "nil", actionTitle: "enter hour")
                       return false
        }
        else if recipeMinuteTxtField.text!.isEmpty{
                   alert(alertTitle: "Enter minute", alertMessage: "nil", actionTitle: "enter minute")
            return false

        }
        else if recipePeopleTxtField.text!.isEmpty{
            alert(alertTitle: "Enter people", alertMessage: "nil", actionTitle: "enter people")
                       return false
        }
        else if descriptionTextView.text!.isEmpty{
                alert(alertTitle: "Enter description", alertMessage: "nil", actionTitle: "enter description")
                           return false
        }
        else  if addIngredientArray.isEmpty{
            alert(alertTitle: "enter ingredient", alertMessage: "", actionTitle: "enter ingredient")
            return false
        }
       else if addStepArray.isEmpty{
            alert(alertTitle: "enter step", alertMessage: "", actionTitle: "enter step")
            return false
        }
//        else if type == "select"{
//            alert(alertTitle: "select any one", alertMessage: "", actionTitle: "select level")
//            return false
//        }
        else{
            if !isValidHour(hour: recipeHourTxtField.text!){
                alert(alertTitle: "enter valid hour", alertMessage: "", actionTitle: "re-enter hour")
                return false
            }
            else if !isValidMinute(min: recipeMinuteTxtField.text!){
                alert(alertTitle: "invalid min", alertMessage: "", actionTitle: "enter valid minute")
                return false
            }
            else{
                print("data is valid")
                return true
            }
        }
        return false
    }
    func isValidHour(hour:String) -> Bool{
        let hourRegEx = "[0-9]"
        let hourTest = NSPredicate(format:"SELF MATCHES %@", hourRegEx)
        return hourTest.evaluate(with: hour)
    }
    func isValidMinute(min:String) -> Bool{
        let minRegEx = "[0-9]{1,2}"
        let minTest = NSPredicate(format:"SELF MATCHES %@", minRegEx)
        return minTest.evaluate(with: min)
    }
  
    func alert(alertTitle : String,alertMessage : String,actionTitle : String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel) { (alert) in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        if addRecipeDetail(){
           if let imageData = recipeImageView.image!.jpegData(compressionQuality: 0.5){
                 addRecipeApi(data_img: imageData)
            }
            print("valid data")
        }else{
            print("invalid data")
        }
    }
    
    
    func addRecipeApi(data_img:Data?){
        let url = "http://192.168.2.221:3000/recipe/add" /* your API url */
        let headers: HTTPHeaders = ["user_authtoken":authtoken]

        var ingredientArray:[String] = []
        for i in 0..<addIngredientArray.count{
            ingredientArray.append(addIngredientArray[i].ingredientName)
        }
       let ingredietString = ingredientArray.joined(separator: ",")

        var stepArray : [String] = []
        for i in 0..<addStepArray.count{
            stepArray.append(addStepArray[i].stepName)
        }
        let stepString = stepArray.joined(separator: ",")
        print(stepString)
        AF.upload(multipartFormData: { MultipartFormData in
            let uploadDict = ["recipe_name":self.recipeNameTxtField.text!,"type_id":"2","recipe_level":self.type,"recipe_cookingtime":"10","recipe_ingredients":ingredietString,"recipe_steps":stepString,"recipe_people":self.recipePeopleTxtField.text!,"recipe_description":self.descriptionTextView.text!]

            MultipartFormData.append(data_img!, withName: "recipe_image" , fileName: "image.jpeg" , mimeType: "image/jpeg")
            for(key,value) in uploadDict {
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                 }
        },to: url, headers:headers).responseJSON { (response) in
                 debugPrint("SUCCESS RESPONSE: \(response)")
        }
    }
}

