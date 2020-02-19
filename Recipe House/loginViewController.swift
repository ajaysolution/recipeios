//
//  loginViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/19/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailBtnLabel: UIButton!
    
    @IBOutlet weak var createBtnLabel: UIButton!
    
    @IBOutlet weak var guestBtnLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text , emailTextField.text?.count != 0 else{
          alert(alertTitle: "email", alertMessage: "Email is nil", actionTitle: "enter email")
            return
        }
        if isValidEmail(emailID: email) == false{
            alert(alertTitle: "Invalid email", alertMessage: "email", actionTitle: "re-enter email")
          
        }
        guard let password = passwordTextField.text , passwordTextField.text?.count != 0 else{
            alert(alertTitle: "password is nil", alertMessage: "password", actionTitle: "enter password")
                
                return
            }
        if isValidPassword(pass: password) == false{
            alert(alertTitle: "invalid password", alertMessage: "password", actionTitle: "Re-enter password")
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
        present(alert, animated: true, completion: nil)    }
    

}