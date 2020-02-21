//
//  forgetPasswordViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/21/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit

class forgetPasswordViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var OTPButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        OTPButtonOutlet.layer.cornerRadius = OTPButtonOutlet.frame.size.height/2
        OTPButtonOutlet.layer.borderColor = UIColor.black.cgColor
        OTPButtonOutlet.layer.borderWidth = 2.0
    }
    
    @IBAction func OTPButton(_ sender: UIButton) {
        
    }
    
    

}
