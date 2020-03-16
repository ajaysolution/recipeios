//
//  profileViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/25/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PINRemoteImage

var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

let loginEmail = ""
class profileViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    let userDefault = UserDefaults.standard
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var changePassOutlet: UIButton!
    @IBOutlet weak var logoutOutlet: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        if authtoken != "" {
                super.viewDidLoad()
               
               profileApi()
               print(authtoken)
               print(email)
               imageView()
               buttonLayout()
            }else if authtoken == ""{
                let alert = UIAlertController(title: "First you have to log in", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "log in", style: .default) { (alert) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
        }
   
    }
    func imageView(){
        profileImage.layer.cornerRadius = (profileImage.frame.size.width)/2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    func  buttonLayout(){
           changePassOutlet.layer.cornerRadius = changePassOutlet.frame.size.height/2
           logoutOutlet.layer.cornerRadius = logoutOutlet.frame.size.height/2
    }
    @IBAction func selesctProfilePicture(_ sender: UIButton) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = true
        present(image, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImage.image = image
            userProfile()
            }
            else{
            print(Error.self)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePasswordButton(_ sender: UIButton) {
  performSegue(withIdentifier: "change", sender: self)
    }
    @IBAction func logoutButton(_ sender: UIButton) {
       self.userDefault.set(false, forKey: "user_authtokenkey")
       self.userDefault.set(authtoken, forKey: "user_authtoken")
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
    func userProfile(){
        let url = NSURL(string: "http://192.168.2.221:3000/user/profile/update")
            
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
            
            let boundary = generateBoundaryString()

        //define the multipart request type

            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
            if (profileImage.image == nil)
            {
                return
            }
            
        let image_data = profileImage.image!.pngData()
            
            if(image_data == nil)
            {
                return
            }
            
            let body = NSMutableData()
            
        _ = "test.png"
        _ = "image/png"
            
      

        request.httpBody = body as Data
            
            
        let session = URLSession.shared

            
        let task = session.dataTask(with: request as URLRequest) {
                (
                data, response, error) in
                
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                    print("error")
                    return
                }
                
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString!)
                
            }
            
            task.resume()
    }
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }

    func profileApi(){
    indicatorStart()
        let url = URL(string: "http://192.168.2.221:3000/user/profile")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(email, forHTTPHeaderField: "user_email")
        request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
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
                    let userdetails=json["user_details"]
                    let firstname = userdetails["user_firstname"]
                    let lastname = userdetails["user_lastname"]
                    self.NameLabel.text = "\(firstname.string! + " " + lastname.string!)"
             
                    let gender = userdetails["user_gender"]
                    if gender == "m"{
                        self.genderLabel.text = "Male"
                    }else if gender == "f"{
                        self.genderLabel.text = "Female"
                    }
                    self.numberLabel.text = userdetails["user_phone"].stringValue
                    self.emailLabel.text = userdetails["user_email"].string
                   let image = userdetails["user_profile"].string
                    self.profileImage.pin_setImage(from: URL(string: "http://192.168.2.221:3000/userimages/1584344826009-user.jpg"))
                }
            }
            else{
                
            }
        }
        task.resume()
        
    }
    func profileImageApi(){
    indicatorStart()
        let url = URL(string: "http://192.168.2.221:3000/user/profile")
        var request = URLRequest(url: url!)
        request.setValue("application/form-data", forHTTPHeaderField: "Content-Type")
       // request.addValue(email, forHTTPHeaderField: "user_email")
        request.addValue(authtoken, forHTTPHeaderField: "user_authtoken")
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["user_email":email,"user_profile":"name.png"]
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
                    self.indicatorEnd()
               
                }
                
            }
            else{
                
            }
        }
        task.resume()
        
    }
    
   
}
