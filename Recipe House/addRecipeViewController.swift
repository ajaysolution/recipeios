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

var editRecipeId : Int = 0
class addRecipeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {
    
    var levelDrop = DropDown()
    var typeDropDown = DropDown()
    var addIngredientArray = [Ingredient]()
    var editIngredientArray = [Ingredient]()
    var addStepArray = [Step]()
    var arrayToString : String = ""
    var levelSelect : String = ""
    var typeSelect : Int = 0
    var sections = ["Ingredient","Steps"]
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeNameTxtField: UITextField!
    @IBOutlet weak var recipeHourTxtField: UITextField!
    @IBOutlet weak var recipeMinuteTxtField: UITextField!
    @IBOutlet weak var recipePeopleTxtField: UITextField!
    @IBOutlet weak var ingredientTxtField: UITextField!
    @IBOutlet weak var stepTxtField: UITextField!
    @IBOutlet weak var levelButtonOutlet: UIButton!
    @IBOutlet weak var typeButtonOutlet: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    override func viewDidLoad() {
            super.viewDidLoad()
          submitButtonOutlet.layer.cornerRadius = submitButtonOutlet.frame.size.height/2
        tableView.register(UINib(nibName: "ingredientTableViewCell", bundle: nil), forCellReuseIdentifier: "ingredient")
    }
    override func viewDidAppear(_ animated: Bool) {
        if authtoken != ""{
            if editRecipeId == 0{
                   print("nil")
                   recipeImageView.image = nil
                   recipeNameTxtField.text = ""
                   recipeHourTxtField.text = ""
                   recipeMinuteTxtField.text = ""
                   recipePeopleTxtField.text = ""
                   descriptionTextView.text = ""
                   levelButtonOutlet.isSelected = false
                   typeButtonOutlet.isSelected = false
                   addIngredientArray.removeAll()
                   addStepArray.removeAll()
             }else if editRecipeId != 0{
                         recipeDetailApi()
                          print(editRecipeId)
            }
        }else if authtoken == ""{
                let alert = UIAlertController(title: "First you have to log in", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "log in", style: .default) { (alert) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
        }
     
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
         cell.addRecipeTextCell.tag = indexPath.row
        cell.addRecipeTextCell.delegate = self
        if sections[indexPath.section] == "Ingredient"{
            cell.addRecipeTextCell.text = addIngredientArray[indexPath.row].ingredientName
           
            
//            let data = Ingredient()
//            data.ingredientName = cell.addRecipeTextCell.text!
//            editIngredientArray.append(data)
        }
        if sections[indexPath.section] == "Steps"{
            cell.addRecipeTextCell.text = addStepArray[indexPath.row].stepName
//            cell.addRecipeTextCell.tag = indexPath.row
//            cell.addRecipeTextCell.delegate = self
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .normal, title: "delete") { (UIContextualAction, UIView, success :(Bool) -> Void) in
//            success(true)
//            if self.sections[indexPath.section] == "Ingredient"{
//                self.addIngredientArray.remove(at: indexPath.row)
//            }
//            if self.sections[indexPath.section] == "Steps"{
//                self.addStepArray.remove(at: indexPath.row)
//
//            }
//            tableView.reloadData()
//        }
//        delete.backgroundColor = .red
//        return UISwipeActionsConfiguration(actions: [delete])
//    }
  
    func textFieldDidEndEditing(_ textField: UITextField) {
        addIngredientArray[textField.tag].ingredientName = textField.text!
       // addStepArray[textField.tag].stepName = textField.text!
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (UIContextualAction, UIView, success :(Bool) -> Void) in
            success(true)
            if self.sections[indexPath.section] == "Ingredient"{
              //  self.addIngredientArray.insert(, at: addIngredientArray[indexPath.row].ingredientName)
                self.addIngredientArray.remove(at: indexPath.row)
            }
            if self.sections[indexPath.section] == "Steps"{


            }
            tableView.reloadData()
        }
        edit.backgroundColor = .darkGray
        return UISwipeActionsConfiguration(actions: [edit])
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sections[sourceIndexPath.section] == "Ingredient"{
            let movIngreCell = addIngredientArray[sourceIndexPath.item]
            addIngredientArray.remove(at: sourceIndexPath.item)
            addIngredientArray.insert(movIngreCell, at: destinationIndexPath.item)
        }
    if sections[sourceIndexPath.section] == "Steps"{
        let movStepCell = addStepArray[sourceIndexPath.item]
        addStepArray.remove(at: sourceIndexPath.item)
        addStepArray.insert(movStepCell, at: destinationIndexPath.item)
    }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            addIngredientArray.remove(at: indexPath.item)
            addStepArray.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    @IBAction func addIngredientButton(_ sender: UIButton) {
        let ingredientData = Ingredient()
        time()
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
         levelDrop.selectionAction = {  (index: Int, level: String) in
           print("Selected item: \(level) at index: \(index)")
            if level == "easy"{
                self.levelSelect = "easy"
                self.levelButtonOutlet.setTitle("easy", for: .normal)
            }
            else if level == "medium"{
                self.levelSelect = "medium"
                self.levelButtonOutlet.setTitle("medium", for: .normal)
            }
            else{
                self.levelButtonOutlet.setTitle("hard", for: .normal)
                self.levelSelect = "hard"
            }
         }

         levelDrop.bottomOffset = CGPoint(x: 0, y: levelButtonOutlet.bounds.height)
         levelDrop.width = 100
    }
    func typeDropdown(){
        typeDropDown.anchorView = typeButtonOutlet
        typeDropDown.dataSource = ["Dessert","Breakfast","Lunch","Drinks","Pizza","Salads","Main Courses","Side Dishes"]
        typeDropDown.selectionAction = { (index : Int, type : String) in
            if type == "Dessert"{
                self.typeSelect = 1
                self.typeButtonOutlet.setTitle("Dessert", for: .normal)
            }else if type == "Breakfast"{
                self.typeSelect = 2
                self.typeButtonOutlet.setTitle("Breakfast", for: .normal)
            }else if type == "Lunch"{
                self.typeSelect = 3
                self.typeButtonOutlet.setTitle("Lunch", for: .normal)
            }else if type == "Drinks"{
                self.typeSelect = 4
                self.typeButtonOutlet.setTitle("Drinks", for: .normal)
            }else if type == "Pizza"{
                self.typeSelect = 5
                self.typeButtonOutlet.setTitle("Pizza", for: .normal)
            }else if type == "Salads"{
                self.typeSelect = 6
                self.typeButtonOutlet.setTitle("Salads", for: .normal)
            }else if type == "Main Courses"{
                self.typeSelect = 7
                self.typeButtonOutlet.setTitle("Main Courses", for: .normal)
            }else {
                self.typeSelect = 8
                self.typeButtonOutlet.setTitle("Side Dishes", for: .normal)
            }
        }
        typeDropDown.bottomOffset = CGPoint(x: 0, y: levelButtonOutlet.bounds.height)
                typeDropDown.width = 100
    }
    @IBAction func levelDropdown(_ sender: UIButton) {
        levelDropdown()
        levelDrop.show()
    }
    @IBAction func typeDropDown(_ sender: UIButton) {
        typeDropdown()
        typeDropDown.show()
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
        else if typeButtonOutlet.titleLabel?.text == "select"{
            alert(alertTitle: "select any one", alertMessage: "", actionTitle: "select type")
            return false
        }
        else if levelButtonOutlet.titleLabel?.text == "select"{
            alert(alertTitle: "select any one", alertMessage: "", actionTitle: "select level")
            return false
        }
        else{
            if !isValidHour(hour: recipeHourTxtField.text!){
                alert(alertTitle: "enter valid hour", alertMessage: "", actionTitle: "re-enter hour")
                return false
            }
            else if !isValidMinute(min: recipeMinuteTxtField.text!){
                alert(alertTitle: "invalid min", alertMessage: "", actionTitle: "enter valid minute")
                return false
            }
            else if !isValidpeople(people: recipePeopleTxtField.text!){
                alert(alertTitle: "invalid format people", alertMessage: "", actionTitle: "limited people")
                return false
            }
            else if recipeImageView.image == nil{
                alert(alertTitle: "select image", alertMessage: "", actionTitle: "select image")
                return false
            }
            return true
        }
    }
    func isValidHour(hour:String) -> Bool{
       // let hourRegEx = "[0-2]{1}[0-3]{1}"
        let hourRegEx = "[0-9]{1}"
        let hourTest = NSPredicate(format:"SELF MATCHES %@", hourRegEx)
        return hourTest.evaluate(with: hour)
    }
    func isValidMinute(min:String) -> Bool{
        let minRegEx = "[0-5]{1}[0-9]{1}"
        let minTest = NSPredicate(format:"SELF MATCHES %@", minRegEx)
        return minTest.evaluate(with: min)
    }
    func isValidpeople(people:String) -> Bool{
        let peopleRegEx = "[0-2]{1}[0-5]{1}"
        let peopleTest = NSPredicate(format:"SELF MATCHES %@", peopleRegEx)
        return peopleTest.evaluate(with: people)
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
                print(editRecipeId)
                if editRecipeId == 0{
                    if let imageData = recipeImageView.image!.jpegData(compressionQuality: 0.5){
                    addRecipeApi(data_img: imageData)
                    }
                }else if editRecipeId != 0{
                    
                    if let editImage = recipeImageView.image?.jpegData(compressionQuality: 0.5){
                       editRecipeApi(data_img: editImage)
                    }
                }
        }
        navigationController?.popViewController(animated: true)
        editRecipeId = 0
    }
    func addRecipeApi(data_img:Data?){
        let url = "http://127.0.0.1:3000/recipe/add"
        let headers: HTTPHeaders = ["user_authtoken":authtoken]
       
        var ingredientArray:[String] = []
        for i in 0..<addIngredientArray.count{
            print(addIngredientArray[i].ingredientName)
            ingredientArray.append(addIngredientArray[i].ingredientName)
        }
       let ingredietString = ingredientArray.joined(separator: ",")

        var stepArray : [String] = []
        for i in 0..<addStepArray.count{
            stepArray.append(addStepArray[i].stepName)
        }
        let stepString = stepArray.joined(separator: ",")
        let hour = Int(recipeHourTxtField.text!)
        let minute = Int(recipeMinuteTxtField.text!)
        var time = ""
        time = String(hour! * 60 + minute!)
        print(time)
        AF.upload(multipartFormData: { MultipartFormData in
            let uploadDict = ["recipe_name":self.recipeNameTxtField.text!,"type_id":String(self.typeSelect),"recipe_level":self.levelSelect,"recipe_cookingtime":"\(time)","recipe_ingredients":ingredietString,"recipe_steps":stepString,"recipe_people":self.recipePeopleTxtField.text!,"recipe_description":self.descriptionTextView.text!]

            MultipartFormData.append(data_img!, withName: "recipe_image" , fileName: "image.jpeg" , mimeType: "image/jpeg")
            for(key,value) in uploadDict {
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                 }
        },to: url, headers:headers).responseJSON { (response) in
                 debugPrint("SUCCESS RESPONSE: \(response)")
        }
    }
    func recipeDetailApi(){
                 // indicatorStart()
                  let url = URL(string: "http://127.0.0.1:3000/recipe/getrecipe?recipe_id=\(editRecipeId)")
                  var request = URLRequest(url: url!)
                  request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "ContentType")
                  request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
                  request.httpMethod = "GET"

                  let task = URLSession.shared.dataTask(with: request) { data, response, error in
                      guard let data = data,
                          let response = response as? HTTPURLResponse,
                          error == nil else {
                          print("error", error ?? "Unknown error")
                          return
                      }

                      guard (200 ... 299) ~= response.statusCode else {
                          print("statusCode should be 2xx, but is \(response.statusCode)")
                        let alert = UIAlertController(title: "error", message: "\(response)", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                        print("response = \(response)")
                          return
                      }
                      let json = try! JSON(data: data)
                      let responseString = String(data: data, encoding: .utf8)
                      print(json)
                      print(responseString!)

                    let name = json["recipe"]["recipe_name"].stringValue
                    print(name)

                      if responseString != nil{
                          DispatchQueue.main.async(){
                          //  self.indicatorEnd()

                                let recipeImage = json["recipe"]["recipe_image"].stringValue
                                 let type = json["recipe"]["type_name"].stringValue
                                 let recipeName = json["recipe"]["recipe_name"].stringValue
                                 let time = json["recipe"]["recipe_cookingtime"].intValue
                                 let level = json["recipe"]["recipe_level"].stringValue
                                 let description = json["recipe"]["recipe_description"].stringValue
                                 let people = json["recipe"]["recipe_people"].stringValue
                              //   let recipeID = json["recipe"]["recipe_id"].stringValue
                                let ingredient = json["recipe"]["recipe_ingredients"].stringValue
                                let ingredientSplit = ingredient.components(separatedBy: ",")
                                let steps = json["recipe"]["recipe_steps"].stringValue
                                let stepSplit = steps.components(separatedBy: ",")
                                 print(stepSplit)
                                
                            self.recipeNameTxtField.text = recipeName
                            self.typeButtonOutlet.setTitle(type, for: .normal)
                            self.levelSelect = level
                            let typeSwitch = type
                            switch typeSwitch{
                            case "Dessert":
                                self.typeSelect = 1
                            case "Breakfast":
                                self.typeSelect = 2
                            case "Lunch":
                            self.typeSelect = 3
                            case "Drinks":
                            self.typeSelect = 4
                            case "Pizza":
                            self.typeSelect = 5
                            case "Salads":
                            self.typeSelect = 6
                            case "Main Courses":
                            self.typeSelect = 7
                            case "Side Dishes":
                                self.typeSelect = 8
                            default: break
                                
                            }
                            self.levelButtonOutlet.setTitle(level, for: .normal)
                            self.recipePeopleTxtField.text = people
                            self.descriptionTextView.text = description
                            if time >= 60{
                                let hour = time/60
                                let minute = time%60
                                self.recipeHourTxtField.text = String(hour)
                                self.recipeMinuteTxtField.text = String(minute)
                            }else{
                                self.recipeHourTxtField.text = "0"
                                self.recipeMinuteTxtField.text = String(time)
                            }
                            self.recipeImageView.pin_setImage(from: URL(string: "http://127.0.0.1:3000/recipeimages/\(recipeImage)"))

                                for i in 0..<ingredientSplit.count{
                                    let sample = Ingredient()
                                    sample.ingredientName = ingredientSplit[i]
                                    self.addIngredientArray.append(sample)
                                }
                                 for i in 0..<stepSplit.count{
                                     let sample = Step()
                                    sample.stepName = stepSplit[i]
                                    self.addStepArray.append(sample)
                                 }
                                self.tableView.reloadData()
                            }
                      }
                  }
                  task.resume()
    }
    func time(){
        let hour = Int(recipeHourTxtField.text!)
               let minute = Int(recipeMinuteTxtField.text!)
              var time : Int = 0
               time = hour! * 60 + minute!
               print(time)
    }
    func editRecipeApi(data_img:Data?){
        let url = "http://127.0.0.1:3000/recipe/edit"
        let headers: HTTPHeaders = ["user_authtoken":authtoken]
        
        var ingredientArray:[String] = []
        for i in 0..<addIngredientArray.count{
            print(addIngredientArray[i].ingredientName)
            ingredientArray.append(addIngredientArray[i].ingredientName)
        }
       let ingredietString = ingredientArray.joined(separator: ",")

        var stepArray : [String] = []
        for i in 0..<addStepArray.count{
            stepArray.append(addStepArray[i].stepName)
        }
        let stepString = stepArray.joined(separator: ",")
        let hour = Int(recipeHourTxtField.text!)
        let minute = Int(recipeMinuteTxtField.text!)
        var time = ""
        time = String(hour! * 60 + minute!)

        AF.upload(multipartFormData: { MultipartFormData in
            let uploadDict = ["recipe_name":self.recipeNameTxtField.text!,"type_id":String(self.typeSelect),"recipe_level":self.levelSelect,"recipe_cookingtime":"\(time)","recipe_ingredients":ingredietString,"recipe_steps":stepString,"recipe_people":self.recipePeopleTxtField.text!,"recipe_description":self.descriptionTextView.text!,"recipe_id":String(editRecipeId)]

            MultipartFormData.append(data_img!, withName: "recipe_image" , fileName: "image.jpeg" , mimeType: "image/jpeg")
            for(key,value) in uploadDict {
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                 }
        },to: url, headers:headers).responseJSON { (response) in
                 debugPrint("SUCCESS RESPONSE: \(response)")
        }
    }
}


