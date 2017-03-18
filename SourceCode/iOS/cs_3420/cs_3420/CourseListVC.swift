//
//  CourseListVCViewController.swift
//  cs_3420
//
//  Created by Minh Pham on 3/15/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

class CourseListVC: UIViewController {

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var courses = [Course_Grade]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCoursesOfAStudent()
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.slideMenuController()?.addLeftGestures()
    }
    
    func getCoursesOfAStudent() {
        
        if let user = AppState.instance.user {
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
    
    @IBAction func btnOpenMenu_Pressed(_ sender: Any) {
        if let slideMenuVC = self.navigationController?.slideMenuController() {
             slideMenuVC.openLeft()
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
}
