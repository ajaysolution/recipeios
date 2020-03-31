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
      //MARK: - variable , array ,outlet
    var count = 0
    var num : Int = 0
    var myrecipeArray = [HomeRecipe]()
    var finalArray = [HomeRecipe]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var TableView: UITableView!
    //MARK: - viewdidload function
    override func viewDidLoad() {
        if authtoken != "" {
            super.viewDidLoad()
            // myrecipeApi()
            TableView.register(UINib(nibName: "myrecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "myRecipe")
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
    //MARK: - viewwillappear function
    override func viewWillAppear(_ animated: Bool) {
        num = 0
        myrecipeArray.removeAll()
        myrecipeApi()
        TableView.reloadData()
    }
    //MARK: - tableview method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myrecipeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myRecipe", for: indexPath) as! myrecipeTableViewCell
        cell.contentView.layer.cornerRadius = 15.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.masksToBounds = true
        let myRecipeData = myrecipeArray[indexPath.row]
        cell.editButtonOutlet.tag = indexPath.row
        cell.editButtonOutlet.addTarget(self, action: #selector(pressOnEdit(sender:)), for: .touchUpInside)
        cell.favoriteButtonLabel.tag = indexPath.row
        cell.favoriteButtonLabel.addTarget(self, action: #selector(pressOnLike(sender:)), for: .touchUpInside)
        cell.commentButtonLabel.tag = indexPath.row
        cell.commentButtonLabel.addTarget(self, action: #selector(pressOnComment(sender:)), for: .touchUpInside)
        cell.deleteButtonLabel.tag = indexPath.row
        cell.deleteButtonLabel.addTarget(self, action: #selector(pressOnDelete(sender:)), for: .touchUpInside)
        cell.recipeNameLabel.text = myRecipeData.recipeName
        cell.RecipeTypeLabel.text = myRecipeData.type
        cell.levelLabel.text = myRecipeData.level
        cell.descriptionLabel.text = myRecipeData.description
        cell.timeLabel.text = "\(myRecipeData.time) minutes"
        cell.peopleLabel.text = "\(myRecipeData.people) people"
        cell.recipeId = Int(myRecipeData.recipeID)
        cell.count.text = String(myRecipeData.favoriteCount)
        let time = Int(myRecipeData.time)
        if time! > 60{
            let hr = time! / 60
            let min = time! % 60
            cell.timeLabel.text = String(hr)+"h" + " " + String(min)+"m"
        }else{
            cell.timeLabel.text = "\(myRecipeData.time) minutes"
        }
        let like = Int(myRecipeData.recipeLike)
        if like == 0{
            cell.favoriteButtonLabel.setImage(UIImage(named: "grayHeart"), for: .normal)
        }else if like == 1{
            cell.favoriteButtonLabel.setImage(UIImage(named: "redHeart"), for: .normal)
        }
        cell.recipeImageView.pin_updateWithProgress = true
        cell.recipeImageView.pin_setImage(from: URL(string: "http://127.0.0.1:3000/recipeimages/\(myRecipeData.recipeImage)"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 335
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            recipe_id = Int(myrecipeArray[indexPath.row].recipeID)!
            performSegue(withIdentifier: "detail", sender: self)
        }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == myrecipeArray.count - 1{
            num += 10
            myrecipeApi()
        }
    }
    //MARK: - indicator function
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
    //MARK: - edit button pressed function
    @objc func pressOnEdit(sender:UIButton){
        if let cell = self.TableView.cellForRow(at: IndexPath(row: sender.tag, section: 0 )) as? myrecipeTableViewCell{
            editRecipeId = cell.recipeId!
        }
        performSegue(withIdentifier: "edit", sender: self)
    }
    //MARK: - delete button pressed function
    @objc func pressOnDelete(sender:UIButton){
        if let cell = self.TableView.cellForRow(at: IndexPath(row: sender.tag, section: 0 )) as? myrecipeTableViewCell{
            deleteApi(id: cell.recipeId!)
        }
    }
    //MARK: - like button pressed function
    @objc func pressOnLike(sender:UIButton){
        if let cell = self.TableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? myrecipeTableViewCell{
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
    //MARK: - comment button pressed function
    @objc func pressOnComment(sender:UIButton){
        if let cell = self.TableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? myrecipeTableViewCell {
            recipeID = cell.recipeId!
            performSegue(withIdentifier: "comment", sender: self)
        }
    }
    //MARK: - search method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        myrecipeArray = finalArray.filter({ (recipe) -> Bool in
            guard let text = searchBar.text else {return false }
            return recipe.recipeName.contains(text.lowercased())
        })
        TableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        num = 0
        recipeCalling()
    }
    func recipeCalling(){
        myrecipeApi()
        num += 10
    }
    //MARK: - my recipe API
    func myrecipeApi(){
        indicatorStart()
        let url = URL(string: "http://127.0.0.1:3000/recipe/myrecipes?count=\(num)&user_email=\(email)")
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
                print("response = \(response)")
                return
            }
            let json = try! JSON(data: data)
            let responseString = String(data: data, encoding: .utf8)
            self.count = json["recipes"].count
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
                        self.myrecipeArray.append(data)
                        self.finalArray.append(data)
                        self.TableView.reloadData()
                    }
                }
                
            }
            else{
            }
        }
        task.resume()
    }
    //MARK: - like API
    func likeApi(id:Int,likeBool : String){
        let url = URL(string: "http://127.0.0.1:3000/recipe/select/favorite")
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
            
            self.count = json.count
            if responseString != nil{
                DispatchQueue.main.async(){
                    
                }
            }
        }
        task.resume()
    }
    //MARK: - delete API
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
            let responseString = String(data: data, encoding: .utf8)
            if responseString != nil{
                DispatchQueue.main.async(){
                    self.myrecipeArray.removeAll()
                    self.num = 0
                    self.myrecipeApi()
                    self.TableView.reloadData()
                }
            }
        }
        task.resume()
    }
}
