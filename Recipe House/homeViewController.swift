//
//  homeViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/26/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import PINRemoteImage
import DropDown

class homeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
  let filterDrop = DropDown()
    @IBOutlet weak var filterButtonOutlet: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [HomeRecipe]()
    
    var finalArray = [HomeRecipe]()
    var count : Int = 0
    
    var num = 0
    var fav : String = ""
    override func viewDidLoad() {
        if Connection.isConnectedToInternet(){
            if authtoken != ""{
        super.viewDidLoad()
        print(authtoken)
        print(email)
        searchBar.delegate = self
        homeRecipeApi(page: num)
        tableview.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            }
            else{
                homeRecipeApi(page: num)
                tableview.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
                print("not eligible")
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecipeTableViewCell
        cell.favoriteButtonLabel.tag = indexPath.row
        cell.commentButtonLabel.tag = indexPath.row
        cell.commentButtonLabel.addTarget(self, action: #selector(pressOnComment(sender:)), for: .touchUpInside)
        cell.favoriteButtonLabel.addTarget(self, action: #selector(pressOnLike(sender:)), for: .touchUpInside)
        cell.recipeNameLabel.text = itemArray[indexPath.row].recipeName
        cell.RecipeTypeLabel.text = itemArray[indexPath.row].type
        cell.levelLabel.text = itemArray[indexPath.row].level
        cell.recipeId = Int(itemArray[indexPath.row].recipeID)
        cell.descriptionLabel.text = itemArray[indexPath.row].description
        let time = Int(itemArray[indexPath.row].time)
        if time! > 60{
            let hr = time! / 60
            let min = time! % 60
            cell.timeLabel.text = String(hr)+"h" + " " + String(min)+"m"
        }else{
        cell.timeLabel.text = "\(itemArray[indexPath.row].time) minutes"
        }
        cell.peopleLabel.text = "\(itemArray[indexPath.row].people) people"
        cell.count.text = String(itemArray[indexPath.row].favoriteCount)
        let like = Int(itemArray[indexPath.row].recipeLike)
        if like == 0{
            cell.favoriteButtonLabel.setImage(UIImage(named: "grayHeart"), for: .normal)
        }else if like == 1{
            cell.favoriteButtonLabel.setImage(UIImage(named: "redHeart"), for: .normal)
        }
        cell.recipeImageView.pin_updateWithProgress = true
        
        cell.recipeImageView.pin_setImage(from: URL(string: "http://192.168.2.221:3000/recipeimages/\(itemArray[indexPath.row].recipeImage)"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      print(indexPath.row)
    print(itemArray.count)
        if indexPath.row == itemArray.count - 1{
            print("call")
            num += 10
            homeRecipeApi(page: num)
        }
    }
    @objc func pressOnLike(sender:UIButton){
        if let cell = self.tableview.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? RecipeTableViewCell{
            if (cell.favoriteButtonLabel.currentImage?.isEqual(UIImage(named: "grayHeart")))!{
                cell.favoriteButtonLabel.setImage(UIImage(named: "redHeart" ), for: .normal)
                favoriteApi(id: cell.recipeId!, likeBool: "true")
                itemArray[sender.tag].favoriteCount += 1
                let add = itemArray[sender.tag].favoriteCount
                cell.count.text = String(add)
            }
            else if (cell.favoriteButtonLabel.currentImage?.isEqual(UIImage(named: "redHeart")))!{
                cell.favoriteButtonLabel.setImage(UIImage(named: "grayHeart"), for: .normal)
                favoriteApi(id: cell.recipeId!, likeBool: "false")
                 itemArray[sender.tag].favoriteCount -= 1
                let less=itemArray[sender.tag].favoriteCount
                cell.count.text = String(less)
            }
            
        }
      
    }
    @objc func pressOnComment(sender:UIButton){
        performSegue(withIdentifier: "comment", sender: self)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        itemArray = finalArray.filter({ (recipe) -> Bool in
            guard let text = searchBar.text else {return false }
            return recipe.recipeName.contains(text)
        })
    
        tableview.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        num=0
        recipeCalling()
    }
    func recipeCalling(){
        homeRecipeApi(page: num)
        num += 10
    }
    func filter(){
        filterDrop.anchorView = filterButtonOutlet
        filterDrop.dataSource = ["level","like"]
         filterDrop.selectionAction = {  (index: Int, item: String) in
           print("Selected item: \(item) at index: \(index)")
            if item == "level"{
                self.itemArray = self.finalArray.filter({$0.level == "easy"})
                print("level")
            }
            else if item == "like"{
                self.itemArray = self.finalArray.filter({$0.recipeLike == "0"})
            }
            self.tableview.reloadData()
         }

         filterDrop.bottomOffset = CGPoint(x: -50, y: filterButtonOutlet.bounds.height)
         filterDrop.width = 100
    }
    @IBAction func filterButton(_ sender: UIButton) {
        filter()
        filterDrop.show()
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
    func homeRecipeApi(page : Int){
        indicatorStart()
        let url = URL(string: "http://192.168.2.221:3000/recipe/getrecipes?count=\(page)")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
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
                            let type = json[i]["type_name"].stringValue
                            let recipeName = json[i]["recipe_name"].stringValue
                            let time = json[i]["recipe_cookingtime"].stringValue
                            let level = json[i]["recipe_level"].stringValue
                            let description = json[i]["recipe_description"].stringValue
                            let people = json[i]["recipe_people"].stringValue
                            let favCount = json[i]["favoriteCount"].int!
                            let recipeID = json[i]["recipe_id"].stringValue
                            let recipeLike = json[i]["recipeLike"].stringValue
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
                            data.recipeID = recipeID
                            data.recipeLike = recipeLike
                            self.itemArray.append(data)
                            self.finalArray.append(data)
                            self.tableview.reloadData()
                        }
                      }
                      
                  }
                  else{
                      
                  }
              }

              task.resume()
        indicatorEnd()
          }
    func favoriteApi(id:Int,likeBool : String){
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

