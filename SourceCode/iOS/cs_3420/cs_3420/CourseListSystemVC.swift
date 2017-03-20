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
        loadAllCoursesFromDB(indicator: false)

        tableView.addPullRefresh { [weak self] in

            self?.loadAllCoursesFromDB(indicator: false)
            self?.tableView.stopPullRefreshEver()
        }
    }

    public func loadAllCoursesFromDB(indicator: Bool) {

        if indicator { showProgressUpdating() }
        DataService.instance.getAllCourses { (err, courses) in
            if indicator { self.dismissProgress() }

            if let err = err {
                print(err)

                self.showError(err: err)
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

    func loadUI() {

        if isSelectingList {
            lblTotal.text = "0"
            lblSelected.text = "Selected: "
            lblTitle.text = "Select Course"
            btnLeftMenu.setImage(UIImage(named: "back"), for: .normal)
        } else {

            lblTotal.text = "\(self.courses.count)"
        }
        
        self.tableView.reloadData()
    }

    @IBAction func btnLeftMenu_Pressed(_ sender: Any) {
        
        if !isSelectingList {
            slideMenuController()?.openLeft()
        }else {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func btnAddNewCourse_Pressed(_ sender: Any) {

        if !isSelectingList {
            performSegue(withIdentifier: "courseSysToDetailSys", sender: courses)
        }else {
            
            //let arrCourses = [self.courses[0], self.courses[1]]
            let arrCourses = self.getCoursesSelected()
            
            let dict = [CONSTANTS.courses_grades.ASSIGNMENT: CONSTANTS.courses_grades.DEFAULT_GRADE,
                        CONSTANTS.courses_grades.FINAL: CONSTANTS.courses_grades.DEFAULT_GRADE,
                        CONSTANTS.courses_grades.MIDTERM: CONSTANTS.courses_grades.DEFAULT_GRADE,
                        CONSTANTS.courses_grades.QUIZ_1: CONSTANTS.courses_grades.DEFAULT_GRADE,
                        CONSTANTS.courses_grades.QUIZ_2: CONSTANTS.courses_grades.DEFAULT_GRADE]
            
            
            var countDown = 0
            for course in arrCourses {
                DataService.instance.addCoursesForStudent(user: student!, course: course, data: dict) { (err) in
                    
                    countDown += 1
                    
                    if (countDown == arrCourses.count) {
                        let _ = self.navigationController?.popViewController(animated: true)
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        let course = self.courses[indexPath.row]

        if !isSelectingList && editingStyle == .delete {

            Libs.showAlertView(title: "Alert", message: "Do you want to delete \'\(course.name)\'?", {

                // Agree to DELETE

                self.showProgressDeleting()
                DataService.instance.deleteCourse(course: course) { (err) in
                    self.dismissProgress()

                    if let err = err {
                        self.showError(err: err)
                        return
                    }

                    self.courses.remove(at: indexPath.row)
                    //self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.loadUI()
                }

            })
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if !isSelectingList {
            let course = courses[indexPath.row]
            performSegue(withIdentifier: "courseSysToDetailSys", sender: course)
            
        }else {
            
            
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.accessoryType == .none {
                    cell.accessoryType = .checkmark
                }else if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                }
            }
            
            lblTotal.text = "\(getCoursesSelected().count)"
        }
    }
    
    func getCoursesSelected() -> [Course] {
        
        var arr = [Course]()
        
        for row in 0..<courses.count {
            
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
            if cell?.accessoryType == .checkmark {
                
                arr.append(courses[row])
            }
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
