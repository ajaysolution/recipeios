//
//  profileViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/25/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit

class profileViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var FirstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var changePassOutlet: UIButton!
    @IBOutlet weak var logoutOutlet: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    var token : String = ""
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(token)
        imageView()
        buttonLayout()
    }
    func imageView(){
        profileImage.layer.cornerRadius = (profileImage.frame.size.width)/2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    func  buttonLayout(){
           changePassOutlet.layer.cornerRadius = changePassOutlet.frame.size.height/2
                  changePassOutlet.layer.borderColor = UIColor.black.cgColor
                  changePassOutlet.layer.borderWidth = 2.0
           logoutOutlet.layer.cornerRadius = logoutOutlet.frame.size.height/2
                  logoutOutlet.layer.borderColor = UIColor.black.cgColor
                  logoutOutlet.layer.borderWidth = 2.0
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
        }else{
            print(Error.self)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func changePasswordButton(_ sender: UIButton) {
        
    }
    @IBAction func logoutButton(_ sender: UIButton) {
        
    }
}
