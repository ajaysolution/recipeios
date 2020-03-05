//
//  favoriteViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/26/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import PINRemoteImage

class favoriteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var count = 0
    var favoriteArray = [HomeRecipe]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        if authtoken != "" {
               super.viewDidLoad()
                 favoriteApi()
               }else if authtoken == ""{
                   let alert = UIAlertController(title: "First you have to log in", message: "", preferredStyle: .alert)
                   let action = UIAlertAction(title: "log in", style: .default) { (alert) in
                       self.navigationController?.popToRootViewController(animated: true)
                   }
                   alert.addAction(action)
                   present(alert, animated: true, completion: nil)
           }
   

       tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArray.count
       }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! RecipeTableViewCell
        cell.recipeNameLabel.text = favoriteArray[indexPath.row].recipeName
        cell.RecipeTypeLabel.text = favoriteArray[indexPath.row].type
        cell.levelLabel.text = favoriteArray[indexPath.row].level
        cell.descriptionLabel.text = favoriteArray[indexPath.row].description
        cell.timeLabel.text = "\(favoriteArray[indexPath.row].time) minutes"
        cell.peopleLabel.text = "\(favoriteArray[indexPath.row].people) people"
        cell.count.text = favoriteArray[indexPath.row].favoriteCount
           return cell
       }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 330
       }
    func favoriteApi(){
          let url = URL(string: "http://192.168.2.221:3000/recipe/getrecipes")
          var request = URLRequest(url: url!)
          request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
          request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
    request.addValue(email, forHTTPHeaderField: "user_email")
          request.httpMethod = "POST"
       let parameters: [String: Any] = ["count":0]
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
                    for i in 0..<self.count{
                        let recipeImage = json[i]["recipe_image"].stringValue
                        let type = json[i]["type_id"].stringValue
                        let recipeName = json[i]["recipe_name"].stringValue
                        let time = json[i]["recipe_cookingtime"].stringValue
                        let level = json[i]["recipe_level"].stringValue
                        let description = json[i]["recipe_description"].stringValue
                        let people = json[i]["recipe_people"].stringValue
                        let favCount = json[i]["favoriteCount"].stringValue
                      //  let image = UIImage(data: json[i]["recipe_image"])
                
                        print(i)
                        let data = HomeRecipe()
                        data.recipeName = recipeName
                        data.type = type
                        data.time = time
                        data.level = level
                        data.people = people
                        data.description = description
                        data.favoriteCount = favCount
                        data.recipeImage = recipeImage
                        self.favoriteArray.append(data)
                        self.tableView.reloadData()
                    }
                  }
                  
              }
              else{
                  
              }
          }

          task.resume()
      }
    

}
