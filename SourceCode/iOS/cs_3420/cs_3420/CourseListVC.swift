//
//  CourseListVCViewController.swift
//  cs_3420
//
//  Created by Minh Pham on 3/15/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import SloppySwiper

class CourseListVC: UIViewController {

    @IBOutlet weak var lblStudentName: UILabel!
    @IBOutlet weak var btnLeftMenu: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var student: User?
    let isAdmin = AppState.instance.isAdmin!
    var courses = [Course_Grade]()
    var swiper = SloppySwiper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isAdmin {
            getCoursesOfAStudent(student: student)
        }else {
            getCoursesOfAStudent(student: AppState.instance.user)
        }
        
        loadUI()
        setUpTableView()
        handleGoBackSwipeAction(swiper: &self.swiper)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.navigationController?.slideMenuController()?.addLeftGestures()
    }
    
    func getCoursesOfAStudent(student: User?) {
        
        if let user = student{
            if let coursesList = user.course_grades {
                courses = coursesList
                
                for i in 0..<courses.count {
                    let course = courses[i]
                    DataService.instance.getACourseInfo(uid: course.uid_course, { (err, courseInfo) in
                        
                        if let err = err {
                            print (err)
                            return
                        }
                        
                        // Successfully get course info
                        if let courseInfo = courseInfo as? Course {
                            course.courseInfo = courseInfo
                            
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
    }
}

// Take care of UI Events
extension CourseListVC {
    
    func loadUI() {
        
        if isAdmin {
            btnLeftMenu.setImage(UIImage(named: "back"), for: .normal)
            lblStudentName.text = student?.name
        }
    }
    
    @IBAction func btnLeftMenu_Pressed(_ sender: Any) {
        
        if !isAdmin {
            self.navigationController?.slideMenuController()?.openLeft()
        } else {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension CourseListVC: UITableViewDelegate, UITableViewDataSource {
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
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
        self.performSegue(withIdentifier: "toDetailGradesVC", sender: courseGrade)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? DetailGradesVC {
            if let courseGrade = sender as? Course_Grade {
                vc.courseGrade = courseGrade
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if isAdmin {
            if editingStyle == .delete {
                
                let course = (self.courses[indexPath.row].courseInfo)!
                
                Libs.showAlertView(title: "Alert", message: "Do you want to delete \'\(course.name)\'?", {
                    
                    DataService.instance.deleteCoursesForStudent(user: self.student!, course: course, { (err) in
                        
                            self.tableView.reloadData()
                        })
                })
            }
        }
    }
    
    
}
