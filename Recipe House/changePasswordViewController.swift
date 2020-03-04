//
//  changePasswordViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/26/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class changePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var changeButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButtonOutlet.layer.cornerRadius = changeButtonOutlet.frame.size.height/2
    }
    @IBAction func changePasswordButton(_ sender: UIButton) {
        
        changePasswordApi()
    }
    func changePasswordApi(){
           let url = URL(string: "http://192.168.2.221:3000/user/userchangepassword")
           var request = URLRequest(url: url!)
           request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
           request.httpMethod = "POST"
        let parameters: [String: Any] = ["user_email":email,"user_oldpassword":oldPasswordTextField.text!,"user_newpassword":newPasswordTextField.text!]
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
               if responseString != nil{
                   DispatchQueue.main.async(){
                      
                   }
                   
               }
               else{
                   
               }
           }

           task.resume()
       }
}
