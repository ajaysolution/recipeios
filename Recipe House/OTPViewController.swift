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
        forgetApi()
        
    }
    
    @IBAction func otpButton(_ sender: UIButton) {
       
    }
    @objc func enableButton() {
        self.OTPOutlet.alpha = 1.0
        self.OTPOutlet.isEnabled = true
    }
    func buttonLayout(){
        OTPOutlet.layer.cornerRadius = OTPOutlet.frame.size.height/2
        OTPOutlet.layer.borderColor = UIColor.black.cgColor
        OTPOutlet.layer.borderWidth = 2.0
        passwodOutlet.layer.cornerRadius = passwodOutlet.frame.size.height/2
        passwodOutlet.layer.borderColor = UIColor.black.cgColor
        passwodOutlet.layer.borderWidth = 2.0
    }
    func forgetApi(){
        let url = URL(string: "http://192.168.2.221:3000/user/forget/token/check")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
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
                }
              
            }
            else{
                
            }
        }

        task.resume()
    }
}
