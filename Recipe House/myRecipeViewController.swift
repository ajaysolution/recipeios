//
//  myRecipeViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/26/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import PINRemoteImage

class myRecipeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    var count = 0
    @IBOutlet weak var searchBar: UISearchBar!
    var myrecipeArray = [HomeRecipe]()
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        if authtoken != "" {
        super.viewDidLoad()
            myrecipeApi()
            TableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell2")
            searchBar.delegate = self
        }else if authtoken == ""{
            let alert = UIAlertController(title: "First you have to log in", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "log in", style: .default) { (alert) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myrecipeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! RecipeTableViewCell
        let myRecipeData = myrecipeArray[indexPath.row]
        cell.favoriteButtonLabel.tag = indexPath.row
        cell.favoriteButtonLabel.addTarget(self, action: #selector(pressOnLike(sender:)), for: .touchUpInside)
        cell.commentButtonLabel.tag = indexPath.row
        cell.commentButtonLabel.addTarget(self, action: #selector(pressOnComment(sender:)), for: .touchUpInside)
        cell.recipeNameLabel.text = myRecipeData.recipeName
        cell.RecipeTypeLabel.text = myRecipeData.type
        cell.levelLabel.text = myRecipeData.level
        cell.descriptionLabel.text = myRecipeData.description
        cell.timeLabel.text = "\(myRecipeData.time) minutes"
        cell.peopleLabel.text = "\(myRecipeData.people) people"
        cell.recipeId = Int(myRecipeData.recipeID)
        cell.count.text = String(myRecipeData.favoriteCount)
        let time = Int(myRecipeData.time)
//        if time! > 60{
//            let hr = time! / 60
//            let min = time! % 60
//            cell.timeLabel.text = String(hr)+"h" + " " + String(min)+"m"
//        }else{
//        cell.timeLabel.text = "\(myRecipeData.time) minutes"
//        }
        let like = Int(myRecipeData.recipeLike)
        if like == 0{
            cell.favoriteButtonLabel.setImage(UIImage(named: "grayHeart"), for: .normal)
        }else if like == 1{
            cell.favoriteButtonLabel.setImage(UIImage(named: "redHeart"), for: .normal)
        }
        cell.recipeImageView.pin_updateWithProgress = true
        
        cell.recipeImageView.pin_setImage(from: URL(string: "http://192.168.2.221:3000/recipeimages/\(myRecipeData.recipeImage)"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    @IBAction func addButton(_ sender: UIButton) {
        performSegue(withIdentifier: "add", sender: self)
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
    @objc func pressOnLike(sender:UIButton){
        if let cell = self.TableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? RecipeTableViewCell{
            if (cell.favoriteButtonLabel.currentImage?.isEqual(UIImage(named: "grayHeart")))!{
                cell.favoriteButtonLabel.setImage(UIImage(named: "redHeart" ), for: .normal)
                likeApi(id: cell.recipeId!, likeBool: "true")
                myrecipeArray[sender.tag].favoriteCount += 1
                let add = myrecipeArray[sender.tag].favoriteCount
                cell.count.text = String(add)
            }
            else if (cell.favoriteButtonLabel.currentImage?.isEqual(UIImage(named: "redHeart")))!{
                cell.favoriteButtonLabel.setImage(UIImage(named: "grayHeart"), for: .normal)
                likeApi(id: cell.recipeId!, likeBool: "false")
                 myrecipeArray[sender.tag].favoriteCount -= 1
                let less=myrecipeArray[sender.tag].favoriteCount
                cell.count.text = String(less)
            }

        }

    }
    @objc func pressOnComment(sender:UIButton){
        performSegue(withIdentifier: "comment", sender: self)
    }
    func myrecipeApi(){
        indicatorStart()
          let url = URL(string: "http://192.168.2.221:3000/recipe/myrecipes?count=0")
          var request = URLRequest(url: url!)
          request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
          request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
    //request.addValue(email, forHTTPHeaderField: "user_email")
          request.httpMethod = "POST"
       let parameters: [String: Any] = ["user_email":email]
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
            
            self.count = json["recipes"].count
            print(self.count)
            let a = json["recipes"][0]["recipe_cookingtime"].stringValue
            print(a)
           
              if responseString != nil{
                  DispatchQueue.main.async(){
                    self.indicatorEnd()
                     for i in 0..<self.count{
                                           
                                           let recipeImage = json["recipes"][i]["recipe_image"].stringValue
                                               let type = json["recipes"][i]["type_name"].stringValue
                                               let recipeName = json["recipes"][i]["recipe_name"].stringValue
                                               let time = json["recipes"][i]["recipe_cookingtime"].stringValue
                                               let level = json["recipes"][i]["recipe_level"].stringValue
                                               let description = json["recipes"][i]["recipe_description"].stringValue
                                               let people = json["recipes"][i]["recipe_people"].stringValue
                                               let favCount = json["recipes"][i]["favoriteCount"].intValue
                                               let recipeID = json["recipes"][i]["recipe_id"].stringValue
                                               let recipeLike = json["recipes"][i]["recipeLike"].stringValue
                                               print(recipeLike)
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
                        print(data.recipeLike)
                                               self.myrecipeArray.append(data)
                                            //   self.finalArray.append(data)
                                               self.TableView.reloadData()
                                           }
                  }
                  
              }
              else{
                  
              }
          }

          task.resume()
      }
    func likeApi(id:Int,likeBool : String){
              let url = URL(string: "http://192.168.2.221:3000/recipe/select/favorite")
              var request = URLRequest(url: url!)
              request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "ContentType")
              request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
              request.httpMethod = "POST"
              
    let parameters: [String: Any] = ["favorite":likeBool,"user_email":email,"recipe_id":id]
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
