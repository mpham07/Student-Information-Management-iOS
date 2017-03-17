//
//  ViewController.swift
//  cs_3420
//
//  Created by Minh Pham on 3/9/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FTIndicator

class LoginVC: UIViewController {

    var courses = [Course]()
    var users = [User]()
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func btnLogin_Pressed(_ sender: Any) {
        
        guard let email = txtEmail.text, let password = txtPassword.text else {
            print("Email or Password is Empty")
            return
        }
        
        FTIndicator.showProgressWithmessage("Loading...", userInteractionEnable: false)
        
        AuthService.instance.logInviaEmailPassword(email: email, password: password) { (err, user) in
        
            if let err = err {
                
                FTIndicator.showError(withMessage: err)
                return
            }
            
            // Successfully login and get user
            if let user = user as? User {
                AppState.instance.user = user
                AppDelegate.instance.switchToCourseNC()
            } else {
                FTIndicator.showError(withMessage: err)
            }
            FTIndicator.dismissProgress()
        }
    }
}


