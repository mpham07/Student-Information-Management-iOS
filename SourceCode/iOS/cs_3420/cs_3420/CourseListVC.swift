//
//  CourseListVCViewController.swift
//  cs_3420
//
//  Created by Minh Pham on 3/15/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import SloppySwiper
import PullToRefreshSwift

class CourseListVC: UIViewController {

    @IBOutlet weak var lblStudentName: UILabel!
    @IBOutlet weak var btnLeftMenu: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddCourse: UIButton!

    var student: User?
    let isAdmin = AppState.instance.isAdmin!
    var courses = [Course_Grade]()
    var swiper = SloppySwiper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        handleGoBackSwipeAction(swiper: &self.swiper)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadDB()
        loadUI()
    }
    
    func loadDB() {
        if isAdmin {
            getCoursesOfAStudent(student: student)
        } else {
            student = AppState.instance.user
            getCoursesOfAStudent(student: student)
        }
    }

    func getCoursesOfAStudent(student: User?) {

        if let user = student {
            
            showProgress(type: .LOADING, userInteractionEnable: true)
            DataService.instance.getCoursesOfAStudent(user: user, { (error, data) in
        
                if let course_grades = data as? [Course_Grade] {
                    self.courses = course_grades
                    user.course_grades = course_grades
                    
                    var countDown = 0
                    
                    if self.courses.count == 0 {
                        self.dismissProgress()
                    }
                    
                    for i in 0..<self.courses.count {
                        let course = self.courses[i]
                        DataService.instance.getACourseInfo(uid: course.uid_course, { (err, courseInfo) in
                            
                            self.dismissProgress()
                            
                            if let err = err {
                                print (err)
                                return
                            }
                            
                            // Successfully get course info
                            if let courseInfo = courseInfo as? Course {
                                course.courseInfo = courseInfo
                                self.student?.course_grades = self.courses
                                
                                countDown += 1
                                
                                if countDown == self.courses.count {
                                    self.tableView.reloadData()
                                }
                            }
                        })
                    }

                }
            })
            
        }
    }
}

// Take care of UI Events
extension CourseListVC {

    func loadUI() {

        if isAdmin {
            btnLeftMenu.setImage(UIImage(named: "back"), for: .normal)
            lblStudentName.text = student?.name

            btnAddCourse.isHidden = false
        }
    }

    @IBAction func btnLeftMenu_Pressed(_ sender: Any) {

        if !isAdmin {
            self.navigationController?.slideMenuController()?.openLeft()
        } else {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func btnAddCourse (_ sender: Any) {
        
        performSegue(withIdentifier: "courseVCtoCourseSysVC", sender: student)
    }
}

extension CourseListVC: UITableViewDelegate, UITableViewDataSource {

    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.addPullRefresh { [weak self] in
            
            self?.loadDB()
            self?.tableView.stopPullRefreshEver()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        lblTotal.text = "\(courses.count)"
        return courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as? CourseCell {

            let course = courses[indexPath.row]
            cell.updateUI(course: course)

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 85.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let courseGrade = courses[indexPath.row]
        courseGrade.student_uid = student?.uid
        self.performSegue(withIdentifier: "toDetailGradesVC", sender: courseGrade)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let vc = segue.destination as? DetailGradesVC {
            if let courseGrade = sender as? Course_Grade {
                vc.courseGrade = courseGrade
            }
        } else if let vc = segue.destination as? CourseListSystemVC {
            
            if let student = sender as? User {
                vc.student = student
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if isAdmin {
            return .delete
        }
        
        return .none
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if isAdmin {
            if editingStyle == .delete {

                let course = (self.courses[indexPath.row].courseInfo)!

                Libs.showAlertView(title: nil, message: "Do you want to delete \'\(course.name)\'?", actionCompletion: {
                    
                    self.showProgress(type: .DELETING, userInteractionEnable: false)
                    DataService.instance.deleteCoursesForStudent(user: self.student!, course: course, { (err) in
                        
                        self.dismissProgress()
                        
                        self.courses.remove(at: indexPath.row)
                        self.student?.course_grades?.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                    })
                }, cancelCompletion: nil)
            }
        }
    }
}
