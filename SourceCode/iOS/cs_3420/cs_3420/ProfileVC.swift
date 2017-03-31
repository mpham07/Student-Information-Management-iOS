//
//  ProfileVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/17/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SDWebImage
import SloppySwiper

class ProfileVC: UIViewController {
    var swiper = SloppySwiper()

    @IBOutlet weak var lblMajor: CustomizedTextField!
    @IBOutlet weak var lblCredits: UILabel!
    @IBOutlet weak var lblName: CustomizedTextField!
    @IBOutlet weak var imgProfile: CustomizedImageView!
    @IBOutlet weak var lblStudentID: CustomizedTextField!
    @IBOutlet weak var lblGPA: UILabel!
    @IBOutlet weak var btnLeftMenu: UIButton!
    @IBOutlet weak var btnRightMenu: CustomizedButton!
    @IBOutlet weak var stackViewForStudent: UIStackView!

    var student: User?

    // isAdminMode to check who is login
    // isAdmin to check who is been working on in this VC
    var isAdminLogin: Bool = false
    var isAdminProfile: Bool = false
    var isEditingProfile: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if student == nil {
            student = AppState.instance.user
        }
        //print(student?.totalCredit)
        if let userAppstate = AppState.instance.user {
            isAdminLogin = userAppstate.isAdmin
        }

        //print(student?.totalCredit)
        isAdminProfile = (student?.isAdmin)!

        // Admin Login && Profile of Student
        if isAdminLogin && !isAdminProfile {
            
            btnLeftMenu.setImage(UIImage(named: "back"), for: .normal)
            handleGoBackSwipeAction(swiper: &self.swiper)

            var countDouwn = 0

            if let course_grades = student?.course_grades {
                for course in course_grades {

                    DataService.instance.getACourseInfo(uid: course.uid_course, { (error, courseInfo) in
                        
                        if let err = error {
                            print(err)
                            return
                        }
                        
                        if let courseInfo = courseInfo as? Course {
                            countDouwn += 1
                            
                            course.courseInfo = courseInfo
                            if countDouwn == course_grades.count {
                                self.updateUI(user: self.student!)
                                return
                            }
                        }
                    })
                }
            }
            
        }else if isAdminLogin && isAdminProfile {
            // Admin Login && Profile of Admin
            
            stackViewForStudent.isHidden = true
        }else if !isAdminLogin {
            // Student Login

        }
        
        if isAdminLogin {
            // Admin Login
            btnRightMenu.isHidden = false
            
        }

        updateUI(user: student!)
    }

    func updateUI(user: User) {

        if let image = user.photoUrl {
            imgProfile.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PROFILE_DEFAULT"), options: .refreshCached)
        }
        //print(user.totalCredit)
        lblName.text = user.name

        guard let student_id = user.student_id else {
            return
        }
        
        lblStudentID.text = student_id
        lblGPA.text = user.GPA
        lblCredits.text = user.totalCredit
        lblMajor.text = user.major
    }

    @IBAction func btnOpenMenu_Pressed(_ sender: Any) {

        if isAdminLogin && !isAdminProfile {
            let _ = self.navigationController?.popViewController(animated: true)
        } else {
            slideMenuController()?.openLeft()
        }
    }
    
    @IBAction func btnRightMenu_Pressed(_ sender: Any) {
        
        if isAdminLogin {
            
            if !isEditingProfile {
                
                self.setEditingModeForUI(value: true)
            }else {
                
                let user = student!
                
                var info = [CONSTANTS.users.NAME: lblName.text!]
                
                if user.isStudent {
                    info[CONSTANTS.users.STUDENT_ID] = lblStudentID.text!
                    info[CONSTANTS.users.MAJOR] = lblMajor.text!
                }

                DataService.instance.updateAUserInfo(user: user, data: info) { (err) in
                    
                    self.setEditingModeForUI(value: false)
                    print("UPDATED user info successfully")
                }
                
                
            }
        }
    }
    
    private func setEditingModeForUI(value: Bool) {
        
        isEditingProfile = value
        lblName.isEditingMode = value
        lblMajor.isEditingMode = value
        lblStudentID.isEditingMode = value
        
        if value {
            btnRightMenu.setToDoneMode()
        }else {
            btnRightMenu.setToEditMode()
        }
    }
}
