//
//  loginViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/19/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class loginViewController: UIViewController {

    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailBtnLabel: UIButton!
    
    @IBOutlet weak var createBtnLabel: UIButton!
    
    @IBOutlet weak var guestBtnLabel: UIButton!
    var alertMessage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//       if Connection.isConnectedToInternet(){
//                    print("connected")
//                }else{
//                    print("disconnected")
//                }
//       
        buttonLayout()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "user_authtokenkey") == true{
            performSegue(withIdentifier: "tab", sender: self)
        }
        return
    }
    @IBAction func loginButton(_ sender: UIButton) {
        if login(){
           if Connection.isConnectedToInternet(){
                print("connection")
            print("valid data")
            loginApi()
            }
        }else{
            alert(alertTitle: "INVALID EMAIL OR PASSWORD", alertMessage: "", actionTitle: "RE-ENTER DATA")
            print("invalid data")
        }

    }
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    func isValidPassword(pass:String) -> Bool {
        let passRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return emailTest.evaluate(with: pass)
    }
    func alert(alertTitle : String,alertMessage : String,actionTitle : String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel) { (alert) in
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    func login()->Bool{
        if emailTextField.text!.isEmpty{
                   alert(alertTitle: "Enter email", alertMessage: "nil", actionTitle: "enter email")
            return false
            
        }
        else if passwordTextField.text!.isEmpty{
            alert(alertTitle: "Enter password", alertMessage: "nil", actionTitle: "enter password")
                       return false
        }
        else{
             if !isValidEmail(emailID: emailTextField.text!){
                //alert(alertTitle: "invalid email", alertMessage: "", actionTitle: "enter valid email")
                 return false
             }
             else if !isValidPassword(pass: passwordTextField.text!){
                 //alert(alertTitle: "enter strong password", alertMessage: "", actionTitle: "re-enter password")
                 return false
             }
             else{
                print("data is valid")
                return true
            }
        }
    }

    @IBAction func forgetButton(_ sender: UIButton) {
        performSegue(withIdentifier: "forget", sender: self)
    }
    @IBAction func registrationButton(_ sender: UIButton) {
        performSegue(withIdentifier: "reg", sender: self)
    }
    @IBAction func guestButton(_ sender: UIButton) {
        performSegue(withIdentifier: "tab", sender: self)
    }
    func buttonLayout(){
        emailBtnLabel.layer.cornerRadius = emailBtnLabel.frame.size.height/2
        emailBtnLabel.layer.borderColor = UIColor.black.cgColor
        emailBtnLabel.layer.borderWidth = 2.0
        createBtnLabel.layer.cornerRadius = createBtnLabel.frame.size.height/2
        createBtnLabel.layer.borderColor = UIColor.black.cgColor
        createBtnLabel.layer.borderWidth = 2.0
        guestBtnLabel.layer.cornerRadius = guestBtnLabel.frame.size.height/2
        guestBtnLabel.layer.borderColor = UIColor.black.cgColor
        guestBtnLabel.layer.borderWidth = 2.0
    }

    func loginApi(){
        let url = URL(string: "http://192.168.2.221:3000/user/login")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["user_email":emailTextField.text!,"user_password":passwordTextField.text!]
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
                  
                    print(responseString!)
                    let message = json["message"]
                    
                    //self.alertMessage = message.stringValue
                    if message == "USER EXISTS"{
                        let authtoken1 = json["user_authtoken"].string
                        let email1 = json["user_email"].string
                        authtoken = authtoken1!
                        email = email1!
                        self.performSegue(withIdentifier: "tab", sender: self)
                   
                        self.userDefault.set(true, forKey: "user_authtokenkey")
                        self.userDefault.set(authtoken, forKey: "user_authtoken")
                        self.userDefault.set(email, forKey: "email")
                    }
                    if message == "USER NOT EXISTS"{
                        let alert = UIAlertController(title: "USER NOT EXISTS", message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Check email or password", style: .cancel) { (action) in
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
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
