//
//  AppDelegate.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/19/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
var authtoken:String = ""
var email : String = ""
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    let window: UIWindow? = nil
    let userDefault = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //if Connection.isConnectedToInternet(){
        if userDefault.bool(forKey: "user_authtokenkey") == true{
           email = self.userDefault.value(forKey: "email") as! String
           authtoken = self.userDefault.value(forKey: "user_authtoken") as! String
                 self.userDefault.synchronize()
                 self.window?.rootViewController?.performSegue(withIdentifier: "tab", sender: nil)
             }
        return true
       // }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

