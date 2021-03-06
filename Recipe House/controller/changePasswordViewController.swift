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
    //MARK: - outlet
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var changeButtonOutlet: UIButton!
    //MARK: - viewdidload function
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButtonOutlet.layer.cornerRadius = changeButtonOutlet.frame.size.height/2
    }
    //MARK: - change password button pressed
    @IBAction func changePasswordButton(_ sender: UIButton) {
        changePasswordApi()
    }
    //MARK: - change password ApI
    func changePasswordApi(){
        let url = URL(string: "http://127.0.0.1:3000/user/userchangepassword")
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
            let message = json["message"].stringValue
            let status = json["status"].stringValue
            if responseString != nil{
                DispatchQueue.main.async(){
                    if status == "OK"{
                        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "okay", style: .cancel) { (action) in
                            if message == "PASSWORD IS CHANGE"{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }else if status == "ERROR"{
                        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "okay", style: .cancel) { (action) in
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "okay", style: .cancel) { (action) in
                            
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            else{
                
            }
        }
        task.resume()
    }
}
