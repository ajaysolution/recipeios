//
//  recipeDetailViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 3/9/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PINRemoteImage

var recipe_id : Int = 0
class recipeDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeBtnOutlet: UIButton!
    @IBOutlet weak var commentBtnOutlet: UIButton!
    @IBOutlet weak var editBtnOutlet: UIBarButtonItem!
    @IBOutlet weak var deleteBtnOutlet: UIBarButtonItem!
    @IBOutlet weak var descriptionLabel: UILabel!
    var sections = ["Ingredient","Steps"]
    var stepArray = [Step]()
    var recipeDetailArray = [HomeRecipe]()
    var count = 0
    var ingredientArray = [Ingredient]()
    var RecipeName:String = ""
    var Types : String = ""
    var Time : String = ""
    var Level : String = ""
    var Description : String = ""
    var People : String = ""
    var RecipeLike : String = ""
    var FavoriteCount : Int = 0
    var RecipeImage : String = ""
    var RecipeID : String = ""
    var buttonShow : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
}
    override func viewDidAppear(_ animated: Bool) {
        ingredientArray.removeAll()
        stepArray.removeAll()
        tableView.reloadData()
        recipeDetailApi()
        recipeID = recipe_id
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sections[section] == "Ingredient"{
            return ingredientArray.count
        }else{
            return stepArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           recipeNameLabel.text = RecipeName
            typeLabel.text = Types
            levelLabel.text = Level
            let time = Int(Time)
        print(time!)
            if time! > 60{
            let hr = time! / 60
            let min = time! % 60
                  timeLabel.text = String(hr)+"h" + " " + String(min)+"m"
            }else{
            timeLabel.text = "\(Time) minutes"
            }
            peopleLabel.text = "\(People) people"
            likeCount.text = String(FavoriteCount)
        descriptionLabel.text = String(Description)
            let like = Int(RecipeLike)
            if like == 0{
                likeBtnOutlet.setImage(UIImage(named: "grayHeart"), for: .normal)
            }else if like == 1{
                likeBtnOutlet.setImage(UIImage(named: "redHeart"), for: .normal)
            }
            recipeImageView.pin_updateWithProgress = true
        recipeImageView.pin_setImage(from: URL(string: "http://127.0.0.1:3000/recipeimages/\(RecipeImage)"))

            if sections[indexPath.section] == "Ingredient"{
                 let bulletPoint: String = "\u{2022}"
                cell.textLabel?.text = "\(bulletPoint) \(ingredientArray[indexPath.row].ingredientName)"
            }
            if sections[indexPath.section] == "Steps"{
                print(stepArray[indexPath.row].stepName.count)
                cell.textLabel?.text = "\(stepArray[indexPath.row].stepName)"
            }
        return cell
  
    }
    

    @IBAction func likeButton(_ sender: UIButton) {
        if (likeBtnOutlet.currentImage?.isEqual(UIImage(named: "grayHeart")))!{
            likeBtnOutlet.setImage(UIImage(named: "redHeart" ), for: .normal)
            likeApi(likeBool: "true")
            print(FavoriteCount)
            FavoriteCount += 1
            likeCount.text = String(FavoriteCount)
        }
        else if (likeBtnOutlet.currentImage?.isEqual(UIImage(named: "redHeart")))!{
            likeBtnOutlet.setImage(UIImage(named: "grayHeart"), for: .normal)
            likeApi(likeBool: "false")
             print(FavoriteCount)
            FavoriteCount -= 1
            likeCount.text = String(FavoriteCount)
            }
        }
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        editRecipeId = recipe_id
              performSegue(withIdentifier: "edit", sender: self)
    }
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
       // print(recipe_id)
        deleteApi(id: recipe_id)
    }
    @IBAction func commentButton(_ sender: UIButton) {
        if authtoken != ""{
             performSegue(withIdentifier: "comment", sender: self)
        }
    }
    func indicatorStart(){
        activityIndicator.center = self.view.center
        
               activityIndicator.hidesWhenStopped = true
               activityIndicator.style = UIActivityIndicatorView.Style.large
                view.isUserInteractionEnabled = false
               view.addSubview(activityIndicator)
               activityIndicator.startAnimating()
    }
    func indicatorEnd(){
        activityIndicator.stopAnimating()
              view.isUserInteractionEnabled = true
    }
    func recipeDetailApi(){
              indicatorStart()
              let url = URL(string: "http://127.0.0.1:3000/recipe/getrecipe?recipe_id=\(recipe_id)")
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
                
                self.count = json["recipes"].count
                        print(self.count)
                let name = json["recipe"]["recipe_name"].stringValue
                print(name)
                
                  if responseString != nil{
                      DispatchQueue.main.async(){
                        self.indicatorEnd()
                                            
                             let ingredient = json["recipe"]["recipe_ingredients"].stringValue
                            let ingredientSplit = ingredient.components(separatedBy: ",")
                            let steps = json["recipe"]["recipe_steps"].stringValue
                            let stepSplit = steps.components(separatedBy: ",")
                             print(stepSplit)
                            
                             self.RecipeName = json["recipe"]["recipe_name"].stringValue
                             self.Types = json["recipe"]["type_name"].stringValue
                             self.Time = json["recipe"]["recipe_cookingtime"].stringValue
                             self.Level = json["recipe"]["recipe_level"].stringValue
                             self.People = json["recipe"]["recipe_people"].stringValue
                             self.Description = json["recipe"]["recipe_description"].stringValue
                             self.FavoriteCount = json["recipe"]["favoriteCount"].intValue
                             self.RecipeImage = json["recipe"]["recipe_image"].stringValue
                             self.RecipeID = json["recipe"]["recipe_id"].stringValue
                             self.RecipeLike = json["recipe"]["recipeLike"].stringValue
                             self.buttonShow = json["recipe"]["userRecipe"].intValue
                        
                        if self.buttonShow == 0{
                            self.deleteBtnOutlet.isEnabled = false
                            self.editBtnOutlet.isEnabled = false
                            self.editBtnOutlet.tintColor = UIColor.clear
                            self.deleteBtnOutlet.tintColor = UIColor.clear
                        }
                            for i in 0..<ingredientSplit.count{
                                let sample = Ingredient()
                                sample.ingredientName = ingredientSplit[i]
                                self.ingredientArray.append(sample)
                            }
                             for i in 0..<stepSplit.count{
                                 let sample = Step()
                                let number : Int = i
                                let step = stepSplit[i]
                                sample.stepName = "\(number+1  ) \(step.self)"
                                 self.stepArray.append(sample)
                             }
                            self.tableView.reloadData()
                        }
                  }
              }

              task.resume()
}
    func likeApi(likeBool : String){
                let url = URL(string: "http://127.0.0.1:3000/recipe/select/favorite")
                var request = URLRequest(url: url!)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "ContentType")
                request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
                request.httpMethod = "POST"
                
      let parameters: [String: Any] = ["favorite":likeBool,"user_email":email,"recipe_id":recipe_id]
                request.httpBody = parameters.percentEncoded()
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data,
                        let response = response as? HTTPURLResponse,
                        error == nil else {
                        print("error", error ?? "Unknown error")
                        return
                    }
                    guard (200 ... 299) ~= response.statusCode else {
                        print("statusCode should be 2xx, but is \(response.statusCode)")
                        print("response = \(response)")
                        return
                    }
                    let json = try! JSON(data: data)
                    let responseString = String(data: data, encoding: .utf8)
             
                    if responseString != nil{
                        DispatchQueue.main.async(){
                        }
                    }
                }
                task.resume()
            }
  func deleteApi(id:Int){
            let url = URL(string: "http://127.0.0.1:3000/recipe/delete")
            var request = URLRequest(url: url!)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "ContentType")
            request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
            request.httpMethod = "POST"
            
  let parameters: [String: Any] = ["recipe_id":id]
            request.httpBody = parameters.percentEncoded()
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {
                    print("error", error ?? "Unknown error")
                    return
                }
                guard (200 ... 299) ~= response.statusCode else {
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
              //  let json = try! JSON(data: data)
                let responseString = String(data: data, encoding: .utf8)
             print(responseString!)
                if responseString != nil{
                    DispatchQueue.main.async(){
                        self.navigationController?.popViewController(animated: true)
                    }
                }
      }
            task.resume()
        }
}
