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
    var email = ""
    //MARK: - outlet
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var NewPasswordTextField: UITextField!
    @IBOutlet weak var OTPOutlet: UIButton!
    @IBOutlet weak var passwodOutlet: UIButton!
    //MARK: - viewdidiload function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.OTPOutlet.alpha = 0.5
        self.OTPOutlet.isEnabled = false
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
        buttonLayout()
    }
    //MARK: - update password button pressed
    @IBAction func updatePasswordButton(_ sender: UIButton) {
        if otpValid(){
            otpCheckApi()
        }else{
            alert(alertTitle: "Invalid data", alertMessage: "", actionTitle: "check otp")
        }
        navigationController?.popToRootViewController(animated: true)
    }
    //MARK: - validation check function
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
    //MARK: - password validation function
    func isValidPassword(pass:String) -> Bool {
        let passRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return emailTest.evaluate(with: pass)
    }
    //MARK: - alert function
    func alert(alertTitle : String,alertMessage : String,actionTitle : String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel) { (alert) in}
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - otpButton pressed
    @IBAction func otpButton(_ sender: UIButton) {
        resendApi()
    }
    //MARK: - enable button
    @objc func enableButton() {
        self.OTPOutlet.alpha = 1.0
        self.OTPOutlet.isEnabled = true
    }
    //MARK: - button layout
    func buttonLayout(){
        OTPOutlet.layer.cornerRadius = OTPOutlet.frame.size.height/2
        passwodOutlet.layer.cornerRadius = passwodOutlet.frame.size.height/2
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
    //MARK: - OTP APi
    func otpCheckApi(){
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
            print(responseString!)
            let status = json["status"].stringValue
            let message = json["message"].stringValue
            
            if responseString != nil{
                DispatchQueue.main.async(){
                    self.indicatorEnd()
                    if status == "OK"{
                        let alert = UIAlertController(title: "password change successfully", message: "", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                        self.navigationController?.popToRootViewController(animated: true)
                    }else if status == "ERROR"{
                        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Re-Enter Data", style: .cancel) { (alert) in}
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
    //MARK: - Re-send OTP API
    func resendApi(){
        indicatorStart()
        let url = URL(string: "http://127.0.0.1:3000/user/login/forget")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
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
            print(response.statusCode)
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            
            if responseString != nil{
                DispatchQueue.main.async(){
                    self.indicatorEnd()
                    self.OTPOutlet.alpha = 0.5
                    self.OTPOutlet.isEnabled = false
                    Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.enableButton), userInfo: nil, repeats: false)
                }
            }
        }
        task.resume()
    }
}
