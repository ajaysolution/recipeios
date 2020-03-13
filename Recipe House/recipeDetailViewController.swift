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
    
    var sections = ["Ingredient","Steps"]
    var datas = [RecipeInstruction]()
    var recipeDetailArray = [HomeRecipe]()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeDetailApi()
        print(recipe_id)
    recipeID = recipe_id
}
    class cell : UITableViewCell{
        
    }
    class cell1 : UITableViewCell{
        
    }
//func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    return self.sections[section]
//}
//func numberOfSections(in tableView: UITableView) -> Int {
//    return sections.count
//}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let recipeData = recipeDetailArray[indexPath.row]
            recipeNameLabel.text = recipeData.recipeName
            typeLabel.text = recipeData.type
            levelLabel.text = recipeData.level
            let time = Int(recipeData.time)
            if time! > 60{
                let hr = time! / 60
                let min = time! % 60
                  timeLabel.text = String(hr)+"h" + " " + String(min)+"m"
            }else{
            timeLabel.text = "\(recipeData.time) minutes"
            }
            peopleLabel.text = "\(recipeData.people) people"
            likeCount.text = String(recipeData.favoriteCount)
            let like = Int(recipeData.recipeLike)
            if like == 0{
                likeBtnOutlet.setImage(UIImage(named: "grayHeart"), for: .normal)
            }else if like == 1{
                likeBtnOutlet.setImage(UIImage(named: "redHeart"), for: .normal)
            }
            recipeImageView.pin_updateWithProgress = true
        recipeImageView.pin_setImage(from: URL(string: "http://192.168.2.221:3000/recipeimages/\(recipeData.recipeImage)"))
        print(datas[indexPath.row].ingredient)
        print(datas[indexPath.row].steps)
      
       cell.textLabel?.text = "\(datas[indexPath.row].ingredient)"
        cell.textLabel?.text = "\(datas[indexPath.row].steps)"
    
        return cell
        
//        if indexPath.row == 0 {
//               let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//                       let Ingredients = recipeDetailArray[indexPath.row].ingredient
//                       let ingredientSplit = Ingredients.components(separatedBy: ",")
//            print(ingredientSplit.count)
//                       for i in 0..<ingredientSplit.count{
//                                  cell.textLabel?.text = ingredientSplit[i]
//                           print(cell.textLabel?.text)
//                              }
//                       return cell
//        }
//         else{
//             let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! cell1
//            let Steps = recipeDetailArray[indexPath.row].steps
//              let stepSplit = Steps.components(separatedBy: ",")
//
//             for i in 0..<stepSplit.count{
//                 cell1.textLabel?.text = stepSplit[i]
//             }
//
//             return cell1
//        }
     
    }
    

    @IBAction func likeButton(_ sender: UIButton) {
        let recipeDetail = HomeRecipe()
        if (likeBtnOutlet.currentImage?.isEqual(UIImage(named: "grayHeart")))!{
            likeBtnOutlet.setImage(UIImage(named: "redHeart" ), for: .normal)
            likeApi(likeBool: "true")
            recipeDetail.favoriteCount += 1
            let add = recipeDetail.favoriteCount
            print(add)
            likeCount.text = String(add)
        }
        else if (likeBtnOutlet.currentImage?.isEqual(UIImage(named: "redHeart")))!{
            likeBtnOutlet.setImage(UIImage(named: "grayHeart"), for: .normal)
            likeApi(likeBool: "false")
           // recipeDetail.favoriteCount 
            let less = recipeDetail.favoriteCount
            print(less)
            likeCount.text = String(less)
            }
        }
    @IBAction func commentButton(_ sender: UIButton) {
        performSegue(withIdentifier: "comment", sender: self)
    }
    func recipeDetailApi(){
              let url = URL(string: "http://192.168.2.221:3000/recipe/getrecipe?recipe_id=\(recipe_id)")
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
                 // print(json)
                  print(responseString!)
                
                self.count = json.count
                        print(self.count)
                
                  if responseString != nil{
                      DispatchQueue.main.async(){
                        
                        for i in 0..<self.count{
                            let recipeImage = json[i]["recipe_image"].stringValue
                             let type = json[i]["type_name"].stringValue
                             let recipeName = json[i]["recipe_name"].stringValue
                             let time = json[i]["recipe_cookingtime"].stringValue
                             let level = json[i]["recipe_level"].stringValue
                             let description = json[i]["recipe_description"].stringValue
                             let people = json[i]["recipe_people"].stringValue
                             let favCount = json[i]["favoriteCount"].int!
                             let recipeID = json[i]["recipe_id"].stringValue
                             let recipeLike = json[i]["recipeLike"].stringValue
                            let ingredient = json[i]["recipe_ingredients"].stringValue
                            let ingredientSplit = ingredient.components(separatedBy: ",")
                            let steps = json[i]["recipe_steps"].stringValue
                            let stepSplit = steps.components(separatedBy: ",")
                             print(stepSplit)
                             let data = HomeRecipe()
                             data.recipeName = recipeName
                             data.type = type
                             data.time = time
                             data.level = level
                             data.people = people
                             data.description = description
                             data.favoriteCount = favCount
                             data.recipeImage = recipeImage
                             data.recipeID = recipeID
                             data.recipeLike = recipeLike
                             let datas = RecipeInstruction()
                             datas.ingredient = ingredientSplit
                             datas.steps = stepSplit
//                            for i in 0..<ingredientSplit.count{
//                                datas.ingredient = ingredientSplit[i]
//                                print(datas.ingredient)
//                               }
//                            for i in 0..<stepSplit.count{
//                                datas.steps = stepSplit[i]
//                                print(datas.steps)
//                            }
                            self.recipeDetailArray.append(data)
                            self.datas.append(datas)
                            self.tableView.reloadData()
                        }
                  
                      }
                      
                  }
                  
              }

              task.resume()
}
    func likeApi(likeBool : String){
                let url = URL(string: "http://192.168.2.221:3000/recipe/select/favorite")
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
                    print(json)
                    print(responseString!)
                  
                  self.count = json.count
                  print(self.count)
                  let a = json[0]["type_id"].stringValue
                  print(a)
                 
                    if responseString != nil{
                        DispatchQueue.main.async(){
                    
                        }
                        
                    }
                    
                }

                task.resume()
            }
}
