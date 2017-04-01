//
//  NewStudentVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/31/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import SloppySwiper

class NewStudentVC: UIViewController {
    var swiper = SloppySwiper()

    @IBOutlet weak var txtEmail: CustomizedTextField!
    @IBOutlet weak var txtPass: CustomizedTextField!
    @IBOutlet weak var txtName: CustomizedTextField!
    @IBOutlet weak var txtId: CustomizedTextField!
    @IBOutlet weak var txtMajor: CustomizedTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        handleGoBackSwipeAction(swiper: &self.swiper)
    }
}

// @IBActions
extension NewStudentVC {

    @IBAction func btnLeftMenu(_ sender: Any) {

        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnRightMenu(_ sender: Any) {
        handleBtnRightMenu_Pressed()
    }

    private func handleBtnRightMenu_Pressed() {

        if self.isTextFeildsNOTEmpty {

            self.showProgress(type: .ADDING, userInteractionEnable: false)

            let info = [CONSTANTS.users.EMAIL: txtEmail.text!,
                        CONSTANTS.users.NAME: txtName.text!,
                        CONSTANTS.users.STUDENT_ID: txtId.text!,
                        CONSTANTS.users.MAJOR: txtMajor.text!,
                        CONSTANTS.users.ROLE: CONSTANTS.users.STUDENT
                        ]

            AuthService.instance.createNewStudentViewEmailPassword(email: txtEmail.text!, password: txtPass.text!, info: info, { (error, uidUser) in
                self.dismissProgress()

                if let err = error {
                    Libs.showAlertView(title: nil, message: err, cancelComplete: nil)
                    return
                }
                
                // Successfuly 
                let _ = self.navigationController?.popViewController(animated: true)
            })
            
        }else {
            // Show err messages
            
        }
    }

    //Temp
    private var isTextFeildsNOTEmpty: Bool {
        //print("views.count = \(view.subviews.count)")
        for txt in view.subviews as [UIView] {
            //print(1)
            if let txt = txt as? UITextField {
                //print(2)
                if txt.text?.characters.count == 0 {
                    return false
                }
            }
        }

        return true
    }
}
