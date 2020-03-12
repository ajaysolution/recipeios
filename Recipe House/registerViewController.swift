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

class registerViewController: UIViewController,UITextFieldDelegate{
    
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
    var selectedGender = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

  buttonLayout()
       
    }
    
   
    @IBAction func radioBtnAction(_ sender: UIButton) {
        if sender.tag == 1{
            maleButtonOutlet.isSelected = true
            femaleButtonOutlet.isSelected = false
            selectedGender = "M"
            print("male")
        }else if sender.tag == 2 {
            maleButtonOutlet.isSelected = false
            femaleButtonOutlet.isSelected = true
             selectedGender = "F"
            print("female")
        }
    }
    
  func  buttonLayout(){
        registerButtonOutlet.layer.cornerRadius = registerButtonOutlet.frame.size.height/2
        backToLoginOutlet.layer.cornerRadius = backToLoginOutlet.frame.size.height/2
    }
    
    @IBAction func registrationButton(_ sender: UIButton) {
        
        if registration(){
            if Connection.isConnectedToInternet(){
            print("data valid")
            registerApi()
            }
        }else{
            print("invalid data")
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 120), animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    func registration()->Bool{
        if firstNameTextField.text!.isEmpty{
            alert(alertTitle: "Enter firstname", alertMessage: "nil", actionTitle: "enter firstname")
            return false
        }
        else if lastNameTextField.text!.isEmpty{
            alert(alertTitle: "Enter lastname", alertMessage: "nil", actionTitle: "enter lastname")
            return false
        }
        else if (femaleButtonOutlet.isSelected == false && maleButtonOutlet.isSelected == false){
            alert(alertTitle: "select gender", alertMessage: "nil", actionTitle: "none of selected")
            print("none of selected")
        }
        else if numberTextField.text!.isEmpty{
            alert(alertTitle: "Enter number", alertMessage: "nil", actionTitle: "enter number")
                       return false
        }
        else if emailTextField.text!.isEmpty{
                   alert(alertTitle: "Enter email", alertMessage: "nil", actionTitle: "enter email")
            return false
            
        }
        else if passwordTextField.text!.isEmpty{
            alert(alertTitle: "Enter password", alertMessage: "nil", actionTitle: "enter password")
                       return false
        }
        else if confirmPasswordTextField.text!.isEmpty{
            alert(alertTitle: "Enter confirm password", alertMessage: "nil", actionTitle: "enter confirm  password")
                       return false
        }
        else{
            if !isValidNumber(value: numberTextField.text!){
                alert(alertTitle: "enter 10 digit number", alertMessage: "", actionTitle: "re-enter number")
                return false
            }
            else if !isValidEmail(emailID: emailTextField.text!){
                alert(alertTitle: "invalid email", alertMessage: "", actionTitle: "enter valid email")
                return false
            }
            else if !isValidPassword(pass: passwordTextField.text!){
                alert(alertTitle: "enter strong password", alertMessage: "", actionTitle: "re-enter password")
                return false
            }
            else if !(confirmPasswordTextField.text! == passwordTextField.text!){
                alert(alertTitle: "password is not same", alertMessage: "", actionTitle: "re-enter confirm password")
                return false
            }
            else{
                print("data is valid")
                return true
            }
        }
        return true
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
    func isValidNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    func alert(alertTitle : String,alertMessage : String,actionTitle : String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel) { (alert) in
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func backToLogin(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
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
    func registerApi(){
        indicatorStart()
        let url = URL(string: "http://192.168.2.221:3000/user/register")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["user_firstname":firstNameTextField.text!,"user_lastname":lastNameTextField.text!,"user_gender":selectedGender,"user_email":emailTextField.text!,"user_password":passwordTextField.text!,"user_phone":numberTextField.text!]
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
