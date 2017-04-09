//
//  CourseListSystemVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/18/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import PullToRefreshSwift
import SDCAlertView


class CourseListSystemVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSelected: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnLeftMenu: UIButton!
    @IBOutlet weak var btnRightMenu: UIButton!

    var student: User?
    var isSelectingList = false
    var courses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()

        isSelectingList = student != nil

        setUpTableView()
        loadAllCoursesFromDB(indicator: true)

        tableView.addPullRefresh { [weak self] in

            self?.loadAllCoursesFromDB(indicator: false)
            self?.tableView.stopPullRefreshEver()
        }
        
        loadMenuButtns()
    }

    public func loadAllCoursesFromDB(indicator: Bool) {

        //if indicator { showProgress(type: .UPDATING, userInteractionEnable: false) }
        DataService.instance.getAllCourses(student: self.student) { (err, courses) in
            //if indicator { self.dismissProgress() }

            if let err = err {
                print(err)
                
                Libs.showAlertView(title: nil, message: err, cancelComplete: nil)
                return
            }

            // Successfully get all courses
            if let coursesList = courses as? [Course] {
                self.courses = coursesList
                self.loadUI()
            }
        }
    }
}

// Take care of the UI Events
extension CourseListSystemVC {

    func loadMenuButtns() {
        if isSelectingList {
            lblTotal.text = "0"
            lblSelected.text = "Selected: "
            lblTitle.text = "Select Course"
            btnLeftMenu.setImage(UIImage(named: "back"), for: .normal)
            
            btnRightMenu.setImage(nil, for: .normal)
            btnRightMenu.setTitle("Done", for: .normal)
            btnRightMenu.setTitleColor(UIColor.lightGray, for: .highlighted)
            btnRightMenu.layer.borderWidth = 1.0
            btnRightMenu.layer.cornerRadius = 4
            btnRightMenu.layer.borderColor = UIColor.white.cgColor
            btnRightMenu.contentHorizontalAlignment = .center
            btnRightMenu.isHidden = true
        }
    }
    
    func loadUI() {

        if !isSelectingList {

            lblTotal.text = "\(self.courses.count)"
        }

        self.tableView.reloadData()
    }

    @IBAction func btnLeftMenu_Pressed(_ sender: Any) {

        if !isSelectingList {
            slideMenuController()?.openLeft()
        } else {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func btnAddNewCourse_Pressed(_ sender: Any) {

        if !isSelectingList {
            performSegue(withIdentifier: "courseSysToDetailSys", sender: courses)
        } else {

            //let arrCourses = [self.courses[0], self.courses[1]]
            let arrCourses = self.getCoursesSelected()

            let dict = [CONSTANTS.courses_grades.ASSIGNMENT: CONSTANTS.courses_grades.DEFAULT_GRADE,
                CONSTANTS.courses_grades.FINAL: CONSTANTS.courses_grades.DEFAULT_GRADE,
                CONSTANTS.courses_grades.MIDTERM: CONSTANTS.courses_grades.DEFAULT_GRADE,
                CONSTANTS.courses_grades.QUIZ_1: CONSTANTS.courses_grades.DEFAULT_GRADE,
                CONSTANTS.courses_grades.QUIZ_2: CONSTANTS.courses_grades.DEFAULT_GRADE]

            var countDown = 0
            for course in arrCourses {

                guard let student = student else {
                    return
                }

                DataService.instance.addCoursesForStudent(user: student, course: course, data: dict) { (err) in

                    countDown += 1

                    if (countDown == arrCourses.count) {
                        let _ = self.navigationController?.popViewController(animated: true)
                        
                        if let pushToken = student.pushToken {
                            
                            self.sendPushNotificationMessage(pushToken: pushToken, title: student.name, message: CONSTANTS.pushService.MESSAGE_ADD_COURSES)
                        }
                    }
                }
            }
        }
    }
}

extension CourseListSystemVC: UITableViewDelegate, UITableViewDataSource {

    func setUpTableView() {

        if isSelectingList {
            tableView.allowsMultipleSelection = true
        }

        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "CourseSystemCell", for: indexPath) as? CourseSystemCell {

            let course = courses[indexPath.row]

            cell.updateUI(course: course)

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 85.0
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {

        if !isSelectingList {
            return .delete
        }

        return .none
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        let course = self.courses[indexPath.row]
        
        Libs.showAlertView(title: nil, message: "Do you want to delete \'\(course.name)\'?", actionCompletion: { 
            // Agree to DELETE
            
            //self.showProgress(type: .DELETING, userInteractionEnable: false)
            DataService.instance.deleteCourse(course: course) { (err) in
                //self.dismissProgress()
                
                if let err = err {
                    
                    Libs.showAlertView(title: nil, message: err, cancelComplete: nil)
                    return
                }
               
                self.courses.remove(at: indexPath.row)
                self.lblTotal.text = "\(self.courses.count)"
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }

        }, cancelCompletion: nil)

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSelectingList {
            let course = courses[indexPath.row]
            performSegue(withIdentifier: "courseSysToDetailSys", sender: course)

        } else {

            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

            btnRightMenu.isHidden = false

            if let countSelectedCell = tableView.indexPathsForSelectedRows {
                lblTotal.text = "\(countSelectedCell.count)"
            }

        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        tableView.cellForRow(at: indexPath)?.accessoryType = .none

        if let indexPaths = tableView.indexPathsForSelectedRows {
            let countSelectedCell = indexPaths.count
            lblTotal.text = "\(countSelectedCell)"

        }else {
            btnRightMenu.isHidden = true
            lblTotal.text = "0"
        }
    }

    func getCoursesSelected() -> [Course] {

        var arr = [Course]()

        guard let indexPaths = tableView.indexPathsForSelectedRows else {
            return arr
        }

        for index in indexPaths {
            
            arr.append(courses[index.row])
        }

        return arr
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let vc = segue.destination as? DetailCourseSystemVC {
            if let course = sender as? Course {
                vc.course = course
            } else if let courses = sender as? [Course] {
                vc.courses = courses
            }
        }
    }
}
