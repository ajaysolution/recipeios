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

class favoriteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    //MARK: - variable ,array ,outlet
    var count = 0
    var num : Int = 0
    var favoriteArray = [HomeRecipe]()
    var finalArray = [HomeRecipe]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: - viewdidload function
    override func viewDidLoad() {
        if authtoken != "" {
            super.viewDidLoad()
            // favoriteApi()
            searchBar.delegate = self
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
    //MARK: - viewwillappear function
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.num = 0
            self.favoriteArray.removeAll()
            self.tableView.reloadData()
            self.favoriteApi()
        }
    }
    //MARK: - Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipe_id = Int(favoriteArray[indexPath.row].recipeID)!
        performSegue(withIdentifier: "detail", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! RecipeTableViewCell
        cell.contentView.layer.cornerRadius = 15.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.masksToBounds = true
        let favoriteRecipeData = favoriteArray[indexPath.row]
        cell.favoriteButtonLabel.tag = indexPath.row
        cell.favoriteButtonLabel.addTarget(self, action: #selector(pressOnLike(sender:)), for: .touchUpInside)
        cell.commentButtonLabel.tag = indexPath.row
        cell.commentButtonLabel.addTarget(self, action: #selector(pressOnComment(sender:)), for: .touchUpInside)
        cell.recipeNameLabel.text = favoriteRecipeData.recipeName
        cell.RecipeTypeLabel.text = favoriteRecipeData.type
        cell.levelLabel.text = favoriteRecipeData.level
        cell.descriptionLabel.text = favoriteRecipeData.description
        cell.timeLabel.text = "\(favoriteRecipeData.time) minutes"
        cell.peopleLabel.text = "\(favoriteRecipeData.people) people"
        cell.recipeId = Int(favoriteRecipeData.recipeID)
        cell.count.text = String(favoriteRecipeData.favoriteCount)
        let time = Int(favoriteRecipeData.time)
        print(time!)
        if time! > 60{
            let hr = time! / 60
            let min = time! % 60
            cell.timeLabel.text = String(hr)+"h" + " " + String(min)+"m"
        }else{
            cell.timeLabel.text = "\(favoriteRecipeData.time) minutes"
        }
        let like = 1
        if like == 1{
            cell.favoriteButtonLabel.setImage(UIImage(named: "redHeart"), for: .normal)
        }
        cell.recipeImageView.pin_updateWithProgress = true
        cell.recipeImageView.pin_setImage(from: URL(string: "http://127.0.0.1:3000/recipeimages/\(favoriteRecipeData.recipeImage)"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == favoriteArray.count - 1{
            num += 10
            favoriteApi()
        }
    }
    //MARK: - like button pressed function
    @objc func pressOnLike(sender:UIButton){
        if let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? RecipeTableViewCell{
            if (cell.favoriteButtonLabel.currentImage?.isEqual(UIImage(named: "grayHeart")))!{
                cell.favoriteButtonLabel.setImage(UIImage(named: "redHeart" ), for: .normal)
                likeApi(id: cell.recipeId!, likeBool: "true")
                favoriteArray[sender.tag].favoriteCount += 1
                let add = favoriteArray[sender.tag].favoriteCount
                cell.count.text = String(add)
            }
            else if (cell.favoriteButtonLabel.currentImage?.isEqual(UIImage(named: "redHeart")))!{
                cell.favoriteButtonLabel.setImage(UIImage(named: "grayHeart"), for: .normal)
                likeApi(id: cell.recipeId!, likeBool: "false")
                favoriteArray[sender.tag].favoriteCount -= 1
                let less=favoriteArray[sender.tag].favoriteCount
                cell.count.text = String(less)
            }
        }
    }
    //MARK: - comment button pressed function
    @objc func pressOnComment(sender:UIButton){
        if let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? RecipeTableViewCell{
            recipeID = cell.recipeId!
            performSegue(withIdentifier: "comment", sender: self)
        }
    }
    //MARK: - search method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        favoriteArray = finalArray.filter({ (recipe) -> Bool in
            guard let text = searchBar.text else {return false }
            return recipe.recipeName.contains(text.lowercased())
        })
        tableView.reloadData()
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
        favoriteApi()
        num += 10
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
    //MARK: - favorite recipe API
    func favoriteApi(){
        indicatorStart()
        let url = URL(string:"http://127.0.0.1:3000/recipe/userfavorites?user_email=\(email)&count=\(num)")
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
            
            self.count = json["recipes"].count
            print(self.count)
            let a = json["recipes"][0]["type_id"].stringValue
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
                        self.favoriteArray.append(data)
                        self.finalArray.append(data)
                        self.tableView.reloadData()
                    }
                }
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
            let responseString = String(data: data, encoding: .utf8)
            if responseString != nil{
                DispatchQueue.main.async(){
                    
                }
            }
        }
        task.resume()
    }
}
