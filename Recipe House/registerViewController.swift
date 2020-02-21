//
//  registerViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/19/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class registerViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var femaleButtonOutlet: UIButton!
    @IBOutlet weak var maleButtonOutlet: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    @IBOutlet weak var backToLoginOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+200)
        buttonLayout()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+200)
    }
    @IBAction func radioBtnAction(_ sender: UIButton) {
        if sender.tag == 1{
            maleButtonOutlet.isSelected = true
            femaleButtonOutlet.isSelected = false
            print("male")
        }else if sender.tag == 2 {
            maleButtonOutlet.isSelected = false
            femaleButtonOutlet.isSelected = true
            print("female")
        }
    }
    
  func  buttonLayout(){
        registerButtonOutlet.layer.cornerRadius = registerButtonOutlet.frame.size.height/2
               registerButtonOutlet.layer.borderColor = UIColor.black.cgColor
               registerButtonOutlet.layer.borderWidth = 2.0
        backToLoginOutlet.layer.cornerRadius = backToLoginOutlet.frame.size.height/2
               backToLoginOutlet.layer.borderColor = UIColor.black.cgColor
               backToLoginOutlet.layer.borderWidth = 2.0
    }
    
    @IBAction func registrationButton(_ sender: UIButton) {
        
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
            print(json)
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
