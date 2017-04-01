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
import FirebaseStorage

class ProfileVC: UIViewController {
    var swiper = SloppySwiper()

    let picker = UIImagePickerController()
    @IBOutlet weak var lblMajor: CustomizedTextField!
    @IBOutlet weak var lblCredits: UILabel!
    @IBOutlet weak var lblName: CustomizedTextField!
    @IBOutlet weak var lblEmail: CustomizedTextField!
    @IBOutlet weak var imgProfile: CustomizedImageView!
    @IBOutlet weak var lblStudentID: CustomizedTextField!
    @IBOutlet weak var lblGPA: UILabel!
    @IBOutlet weak var btnLeftMenu: UIButton!
    @IBOutlet weak var btnRightMenu: CustomizedButton!
    @IBOutlet weak var stackViewForStudent: UIStackView!
    @IBOutlet weak var btnProfilePicture: CustomizedButton!

    var student: User?

    // isAdminMode to check who is login
    // isAdmin to check who is been working on in this VC
    var isAdminLogin: Bool = false
    var isAdminProfile: Bool = false
    var isEditingProfile: Bool = false
    var isSelectedImage: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if student == nil {
            student = AppState.instance.user
        }

        if let userAppstate = AppState.instance.user {
            isAdminLogin = userAppstate.isAdmin
        }

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

        } else if isAdminLogin && isAdminProfile {
            // Admin Login && Profile of Admin

            stackViewForStudent.isHidden = true
            setupUIImagePickerView()
        } else if !isAdminLogin {
            // Student Login
            setupUIImagePickerView()
        }
        
        updateUI(user: student!)
    }

    func updateUI(user: User) {

        if let image = user.photoUrl {
            imgProfile.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PROFILE_DEFAULT"), options: .refreshCached)
        }
        //print(user.totalCredit)
        lblName.text = user.name
        lblEmail.text = user.email

        guard let student_id = user.student_id else {
            return
        }

        lblStudentID.text = student_id
        lblGPA.text = user.GPA
        lblCredits.text = user.totalCredit
        lblMajor.text = user.major
    }

    @IBAction func btnProfilePicture_Pressed(_ sender: Any) {

        present(picker, animated: true, completion: nil)
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

                self.setEditingModeForUI(value: true, isProfilePhotoEditing: false)
                
                if self.isAdminProfile {
                    self.setEditingModeForUI(value: true, isProfilePhotoEditing: true)
                }
                
            } else {

                let user = student!

                var info = [CONSTANTS.users.NAME: lblName.text!]

                if user.isStudent {
                    info[CONSTANTS.users.STUDENT_ID] = lblStudentID.text!
                    info[CONSTANTS.users.MAJOR] = lblMajor.text!
                }
                
                self.showProgress(type: .UPDATING)
                DataService.instance.updateAUserInfo(user: user, data: info) { (err) in
                    self.dismissProgress()
                    
                    if self.isAdminProfile {
                        AppState.instance.user?.name = self.lblName.text!
                        
                        self.handleEditingProfilePhoto()
                    }

                    self.setEditingModeForUI(value: false, isProfilePhotoEditing: false)
                }
            }

        } else if !isAdminLogin {
            // Student Login

            if !isEditingProfile {
                setEditingModeForUI(value: true, isProfilePhotoEditing: true)

            } else {
                handleEditingProfilePhoto()
            }
        }
    }

    private func handleEditingProfilePhoto() {
        
        if isSelectedImage {

            guard let student = student else {
                return
            }

            let imageName = student.photoImagePath

            if let profileImage = self.imgProfile.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                self.showProgress(type: .UPLOADING)
                StorageService.instance.uploadAProfilePictureToStorage(user: student, fileName: imageName, uploadData: uploadData, { (error, path) in
                    self.dismissProgress()
                    if let err = error {
                        print(err)
                    } else {
                        self.setEditingModeForUI(value: false, isProfilePhotoEditing: true)

                        AppState.instance.user?.photoUrl = path as? String
                        self.isSelectedImage  = false
                        return
                    }
                })
            }
        }

        setEditingModeForUI(value: false, isProfilePhotoEditing: true)
    }



    private func setEditingModeForUI(value: Bool, isProfilePhotoEditing: Bool) {

        if isProfilePhotoEditing {
            btnProfilePicture.isUserInteractionEnabled = value
            btnProfilePicture.isProfilePictureEditMode = value

        } else {

            lblName.isEditingMode = value
            lblMajor.isEditingMode = value
            lblStudentID.isEditingMode = value
        }

        isEditingProfile = value

        if value {
            btnRightMenu.setToDoneMode()
        } else {
            btnRightMenu.setToEditMode()
        }
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func setupUIImagePickerView() {

        picker.delegate = self
        picker.allowsEditing = true
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        var selectedImageFromPicker: UIImage?


        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {

            selectedImageFromPicker = editedImage

        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {

            selectedImageFromPicker = originalImage
        }

        if let selectedImageFromPicker = selectedImageFromPicker {

            isSelectedImage = true
            self.imgProfile.image = selectedImageFromPicker
        }

        dismiss(animated: true, completion: nil)
    }
}
