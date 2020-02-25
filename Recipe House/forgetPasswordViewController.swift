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
        OTPButtonOutlet.layer.borderColor = UIColor.black.cgColor
        OTPButtonOutlet.layer.borderWidth = 2.0
    }
    
    @IBAction func OTPButton(_ sender: UIButton) {
        forgetApi()
        self.OTPButtonOutlet.alpha = 0.5
        self.OTPButtonOutlet.isEnabled = false
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
        performSegue(withIdentifier: "otp", sender: self)
        
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
    func forgetApi(){
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
                let OTP = json["user_otptoken"]
                print(OTP)
                otp = OTP.stringValue
                print(otp)
               
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
    


