//
//  DetailCourseSystemVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/18/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import SloppySwiper

class DetailCourseSystemVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var txtNameCourse: UITextField!
    @IBOutlet weak var txtCourseID: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!

    var swiper = SloppySwiper()
    var courses: [Course]?
    var course: Course?
    var isUpdate = false
    let pickerViewTitles = [CONSTANTS.courses.ONLINE,
        CONSTANTS.courses.HYBRID,
        CONSTANTS.courses.IN_CLASS]

    override func viewDidLoad() {
        super.viewDidLoad()

        isUpdate = course != nil
        setUpPickerView()
        loadUI()
        handleGoBackSwipeAction(swiper: &swiper)
    }
}

// Take care of UI events
extension DetailCourseSystemVC {

    func loadUI() {

        if isUpdate {
            if let course = course {
                lblTitle.text = course.course_id
                txtCourseID.text = course.course_id
                txtNameCourse.text = course.name
                lblType.text = course.type

                pickerView.selectRow(getIndexOfRow()!, inComponent: 0, animated: true)
            }
        } else {
            lblTitle.text = "New Course"
            txtCourseID.text = ""
            txtNameCourse.text = ""
            lblType.text = pickerViewTitles[pickerView.selectedRow(inComponent: 0)]
        }
    }

    private func getIndexOfRow() -> Int? {

        for index in 0..<pickerViewTitles.count {
            if pickerViewTitles[index] == course?.type {
                return index
            }
        }

        return nil
    }

    @IBAction func btnLeftNavi_Pressed(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnRightNavi_Pressed(_ sender: Any) {

        if isUIComponentsNOTEmpty() {

            var course: [String: Any] = [
                CONSTANTS.courses.COURSE_ID: txtCourseID.text!,
                CONSTANTS.courses.NAME: txtNameCourse.text!,
                CONSTANTS.courses.TYPE: lblType.text!
            ]

            if !isExistCourseID(newCourseId:txtCourseID.text!) {

                if isUpdate {

                    let uid = self.course?.uid

                    self.showProgressUpdating()
                    DataService.instance.updateCourseInfo(uid: uid!, data: course) { (err) in

                        self.dismissProgress()
                        let _ = self.navigationController?.popViewController(animated: true)
                    }

                } else {
                    // New Course
                    course[ CONSTANTS.courses.REGISTERED] = 0
                    let uid = txtCourseID.text!.replacingOccurrences(of: " ", with: "_")

                    self.showProgressUpdating()
                    DataService.instance.addNewCourse(uid: uid, data: course) { (err) in

                        self.dismissProgress()
                        let _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }else {
                showError(err: "The course \(txtCourseID.text!) is exist!")
            }

        } else {
            showError(err: "Course's name and ID should not empty!")
        }
    }

    private func isExistCourseID(newCourseId: String) -> Bool {

        if let courses = courses {
            for course in courses {

                if course.course_id == txtCourseID.text {
                    return true
                }
            }
        }

        return false
    }

    private func isUIComponentsNOTEmpty() -> Bool {

        if txtNameCourse.text?.characters.count != 0 && txtCourseID.text?.characters.count != 0 {

            return true
        }

        return false
    }
}

extension DetailCourseSystemVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func setUpPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return pickerViewTitles.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return pickerViewTitles[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        lblType.text = pickerViewTitles[row]
    }
}

