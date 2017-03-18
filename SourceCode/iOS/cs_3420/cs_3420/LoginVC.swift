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
import SlideMenuControllerSwift

class LoginVC: UIViewController {

    var slideMenu: SlideMenuController!

    var courses = [Course]()
    var users = [User]()

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        txtEmail.delegate = self
        txtPassword.delegate = self
    }


    @IBAction func btnLogin_Pressed(_ sender: Any) {

        handleButtonLogin()
    }

    func handleButtonLogin() {

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

                self.handlePresentToSlideMenuVC()
            } else {
                FTIndicator.showError(withMessage: err)
            }
            FTIndicator.dismissProgress()
        }
    }

    private func handlePresentToSlideMenuVC() {

        let mainVC: UIViewController!
        
        if AppState.instance.isAdmin! {
            
            mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudentListNC")
        }else {
            mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseListNC")
        }
        
        let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC")

        self.slideMenu = SlideMenuController.init(mainViewController: mainVC, leftMenuViewController: menuVC)

        self.present(self.slideMenu, animated: true, completion: nil)

    }
}

extension LoginVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        handleButtonLogin()
        return true
    }
}


