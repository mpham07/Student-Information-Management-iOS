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

    @IBOutlet weak var lblMajor: UILabel!
    @IBOutlet weak var lblCredits: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: CustomizedImageView!
    @IBOutlet weak var lblStudentID: UILabel!
    @IBOutlet weak var lblGPA: UILabel!
    @IBOutlet weak var btnLeftMenu: UIButton!

    var student: User?

    // isAdminMode to check who is login
    // isAdmin to check who is been working on in this VC
    var isAdminMode: Bool = false
    var isAdmin: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if student == nil {
            student = AppState.instance.user
        }
        //print(student?.totalCredit)
        if let userAppstate = AppState.instance.user {
            isAdminMode = userAppstate.isAdmin
        }

        //print(student?.totalCredit)
        isAdmin = (student?.isAdmin)!

        // Admin Login && Profile of Student
        if isAdminMode && !isAdmin {

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
                                print("aa")
                                self.updateUI(user: self.student!)
                                return
                            }
                        }
                    })
                }
            }
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

        if isAdminMode && !isAdmin {
            let _ = self.navigationController?.popViewController(animated: true)
        } else {
            slideMenuController()?.openLeft()
        }
    }
}
