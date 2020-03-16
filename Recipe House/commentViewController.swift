//
//  commentViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 3/6/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

var recipeID : Int = 0
class commentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var count = 0
    var commentArray = [CommentData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        commentApi()
         
        tableView.register(UINib(nibName: "messageTableViewCell", bundle: nil), forCellReuseIdentifier: "comment")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.estimatedRowHeight = 120
            tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        stackView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print(commentArray.count)
        return commentArray.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! messageTableViewCell
        cell.userName.text = commentArray[indexPath.row].username
        cell.commentLabel.text = commentArray[indexPath.row].userComment
        return cell
    }
    
    
    @IBAction func sendButton(_ sender: UIButton) {
        addCommentApi()
       commentArray.removeAll()
    //    tableView.reloadData()
        commentApi()
       }
    func commentApi(){
              let url = URL(string: "http://192.168.2.221:3000/recipe/comment?comment_status=show")
              var request = URLRequest(url: url!)
              request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "ContentType")
              request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
              request.httpMethod = "POST"
              
    let parameters: [String: Any] = ["user_email":email,"recipe_id":recipeID]
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
                
                self.count = json["comment"].count
                        print(self.count)
                
                let username = json["comment"][0]["comment_text"].stringValue
                print(username)
               
                  if responseString != nil{
                      DispatchQueue.main.async(){
                        
                        for i in 0..<self.count{
                            let comment = json["comment"][i]["comment_text"].stringValue
                            let username = json["comment"][i]["fullname"].stringValue
                            print(username)
                            let data = CommentData()
                            data.username = username
                            data.userComment = comment
                            self.commentArray.append(data)
                            self.tableView.reloadData()
                        }
                  
                      }
                      
                  }
                  
              }

              task.resume()
          }
    func addCommentApi(){
              let url = URL(string: "http://192.168.2.221:3000/recipe/comment?comment_status=add")
              var request = URLRequest(url: url!)
              request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "ContentType")
              request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
              request.httpMethod = "POST"
              
        let parameters: [String: Any] = ["user_email":email,"recipe_id":recipeID,"comment_text":commentTextField.text!]
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
                
                let username = json["comment"][0]["comment_text"].stringValue
                print(username)
               
                  if responseString != nil{
                      DispatchQueue.main.async(){
                        
                        for i in 0..<self.count{
                            let comment = json["comment"][i]["comment_text"].stringValue
                            let username = json["comment"][i]["fullname"].stringValue
                            print(username)
                            let data = CommentData()
                            data.username = username
                            data.userComment = comment
                           self.commentArray.append(data)
//                            self.tableView.reloadData()
                        }
                  
                      }
                      
                  }
                  
              }

              task.resume()
          }
    
}
