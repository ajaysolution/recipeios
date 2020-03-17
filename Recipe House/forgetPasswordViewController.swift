//
//  forgetPasswordViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/21/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class forgetPasswordViewController: UIViewController {

    var otpData = ""
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var OTPButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        OTPButtonOutlet.layer.cornerRadius = OTPButtonOutlet.frame.size.height/2
    }
    
    @IBAction func OTPButton(_ sender: UIButton) {
        if emailValid(){
             forgetApi()
        }else{
            alert(alertTitle: "email is not in database", alertMessage: "", actionTitle: "check email")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "otp"{
            let vc = segue.destination as! OTPViewController
            vc.email = emailTextField.text!
            print(vc.email)
        }
    }
    @objc func enableButton() {
        self.OTPButtonOutlet.alpha = 1.0
           self.OTPButtonOutlet.isEnabled = true
        
       }
    func emailValid() -> Bool{
    if emailTextField.text!.isEmpty{
        alert(alertTitle: "Enter email", alertMessage: "nil", actionTitle: "enter email")
        return false
        } else if !isValidEmail(emailID: emailTextField.text!){
        alert(alertTitle: "check email format", alertMessage: "", actionTitle: "re-enter email")
                    return false
                }
          return true
    }
    func alert(alertTitle : String,alertMessage : String,actionTitle : String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel) { (alert) in}
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func isValidEmail(emailID:String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
           let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailTest.evaluate(with: emailID)
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
            let url = URL(string: "http://192.168.2.221:3000/user/login/forget")
            var request = URLRequest(url: url!)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let parameters: [String: Any] = ["user_email":emailTextField.text!]
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
                let message = json["message"].stringValue
                print(message)

                if responseString != nil{
                    DispatchQueue.main.async(){
                        self.indicatorEnd()
                        if message == "USER EMAIL ID IS NOT MATCH"{
                            self.alert(alertTitle: "USER EMAIL ID IS NOT MATCH", alertMessage: "", actionTitle: "check")
                            
                        }else{
                            self.OTPButtonOutlet.alpha = 0.5
                            self.OTPButtonOutlet.isEnabled = false
                            Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.enableButton), userInfo: nil, repeats: false)
                            self.performSegue(withIdentifier: "otp", sender: self)
                        }
                    }
                  
                }
                else{
                    
                }
            }

            task.resume()
        }
    }
    


