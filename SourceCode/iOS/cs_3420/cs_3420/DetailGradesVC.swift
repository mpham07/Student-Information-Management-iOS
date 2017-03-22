//
//  DetailGradesVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/17/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import SloppySwiper

class DetailGradesVC: UIViewController {

    var swiper = SloppySwiper()
    
    @IBOutlet weak var lblNameCourse: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRightMenu: CustomizedButton!

    var nameGrades: [CONSTANTS.nameOfGrades]!
    var keyGrades: [CONSTANTS.keyOfGrades]!
    var courseGrade: Course_Grade?
    let isAdmin = AppState.instance.isAdmin!
    var isEditingGrade = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        loadUI()
        handleGoBackSwipeAction(swiper: &self.swiper)
    }
    
    @IBAction func btnBack_Pressed(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func loadUI() {
        if let courseGrade = courseGrade {
            
            if let ave = courseGrade.averge {
                lblAverage.text = "\(ave)"
            }else {
                lblAverage.text = CONSTANTS.courses_grades.NONE_AVERAGE
            }
            
            if let courseInfo = courseGrade.courseInfo {
                lblNameCourse.text = courseInfo.course_id
            }
        }
        
        if isAdmin {
            btnRightMenu.isHidden = false
        }
    }
    
    @IBAction func btnRightMenu_Pressed(_ sender: Any) {
        
        if !isEditingGrade {
            
            isEditingGrade = true
            btnRightMenu.setTitle("Done", for: .normal)
            btnRightMenu.setTitleColor(UIColor.lightGray, for: .highlighted)
            tableView.reloadData()
            
        }else {
            
            guard let course = self.courseGrade else {
                return
            }
            
            let grades = getGradesFromCells()
            
            DataService.instance.updateGradesOfACourse(user_uid: course.student_uid!, course_uid: course.uid_course, data: grades, { (err) in
                
                if let err = err {
                    
                    self.showError(err: err)
                }
                
                self.isEditingGrade = false
                self.btnRightMenu.setTitle("Edit", for: .normal)
                self.btnRightMenu.setTitleColor(UIColor.lightGray, for: .highlighted)
                self.loadUI()
                self.tableView.reloadData()
                
                if let previousVC = self.navigationController?.viewControllers[1] as? CourseListVC {
                    previousVC.loadDB()
                }
            })
        }
    }
    
    private func getGradesFromCells() -> [String: Int] {
        
        var grades: [String: Int] = [:]
        for row in 0..<nameGrades.count {
            
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? GradeCell {
                
                if let grade = Int(cell.lblGrade.text!) {
                    grades[keyGrades[row].rawValue] = grade
                }else {
                    grades[keyGrades[row].rawValue] = CONSTANTS.courses_grades.DEFAULT_GRADE
                }
                
                self.courseGrade?.updateGrade(type: keyGrades[row], newGrade: grades[keyGrades[row].rawValue]!)
            }
        }
        
        return grades
    }
}


extension DetailGradesVC: UITableViewDelegate, UITableViewDataSource {

    func setUpTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        nameGrades = [CONSTANTS.nameOfGrades.ASSIGNMENT,
            CONSTANTS.nameOfGrades.QUIZ_1,
            CONSTANTS.nameOfGrades.QUIZ_2,
            CONSTANTS.nameOfGrades.MIDTERM,
            CONSTANTS.nameOfGrades.FINAL]
        
        keyGrades = [CONSTANTS.keyOfGrades.ASSIGNMENT,
                     CONSTANTS.keyOfGrades.QUIZ_1,
                     CONSTANTS.keyOfGrades.QUIZ_2,
                     CONSTANTS.keyOfGrades.MIDTERM,
                     CONSTANTS.keyOfGrades.FINAL]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 70.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "GradeCell", for: indexPath) as? GradeCell {

            if let courseGrade = courseGrade {
                let nameGrade = nameGrades[indexPath.row]
                cell.updateUI(course_grade: courseGrade, name: nameGrade)
                cell.enableEditingGrades(is: isEditingGrade)
            }

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return nameGrades.count
    }
}
