//
//  RegistrationModel.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/21/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import Foundation

class RegistrationModel {
    let firstName : String = ""
    let lastName : String = ""
    let number : Int = 0
    let email : String = ""
    let password : String = ""
    let repeatPassword : String = ""
}
extension RegistrationModel {
    func isValidFirstName() -> Bool {
        return firstName.count > 1
    }
    
    func isValidLastName() -> Bool {
        return lastName.count > 1
    }
    func isValidEmail() -> Bool {
        return email.contains("@") && email.contains(".")
    }
    func isValidPasswordLength() -> Bool {
        return password.count >= 8 && password.count <= 16
    }
    
    func doPasswordsMatch() -> Bool {
        return password == repeatPassword
    }
    
    func isValidPassword() -> Bool {
        return isValidPasswordLength() && doPasswordsMatch()
    }
    
    func isDataValid() -> Bool {
        return isValidFirstName() && isValidLastName() && isValidEmail() && isValidPasswordLength() &&
        doPasswordsMatch()
    }
}
