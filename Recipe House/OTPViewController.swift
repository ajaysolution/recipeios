//
//  OTPViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/24/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
var otp = ""
class OTPViewController: UIViewController {

    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var NewPasswordTextField: UITextField!
    @IBOutlet weak var OTPOutlet: UIButton!
    @IBOutlet weak var passwodOutlet: UIButton!
    
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(otp)
        print(email)
        self.OTPOutlet.alpha = 0.5
        self.OTPOutlet.isEnabled = false
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
     buttonLayout()
    }
    
    @IBAction func updatePasswordButton(_ sender: UIButton) {
        if otpValid(){
            forgetApi()
        }else{
            alert(alertTitle: "Invalid data", alertMessage: "", actionTitle: "check otp")
        }
        navigationController?.popToRootViewController(animated: true)
    }
    func otpValid() -> Bool{
        if otpTextField.text!.isEmpty{
            alert(alertTitle: "alert", alertMessage: "", actionTitle: "enter otp")
            return false
        }else if NewPasswordTextField.text!.isEmpty{
            alert(alertTitle: "alert", alertMessage: "", actionTitle: "enter password")
            return false
        }else{
                if !isValidPassword(pass: NewPasswordTextField.text!){
                    return false
            }
        }
              return true
        }
     
    func isValidPassword(pass:String) -> Bool {
        let passRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return emailTest.evaluate(with: pass)
    }
    func alert(alertTitle : String,alertMessage : String,actionTitle : String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel) { (alert) in}
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func otpButton(_ sender: UIButton) {
       
    }
    @objc func enableButton() {
        self.OTPOutlet.alpha = 1.0
        self.OTPOutlet.isEnabled = true
    }
    func buttonLayout(){
        OTPOutlet.layer.cornerRadius = OTPOutlet.frame.size.height/2
        passwodOutlet.layer.cornerRadius = passwodOutlet.frame.size.height/2
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
    func forgetApi(){
        indicatorStart()
        let url = URL(string: "http://127.0.0.1:3000/user/forget/token/check")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["user_email":email,"user_newpassword":NewPasswordTextField.text!,"user_otptoken":otpTextField.text!]
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
                    self.indicatorEnd()
                }
              
            }
            else{
                
            }
        }

        task.resume()
    }
}
