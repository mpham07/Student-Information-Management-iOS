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

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var courses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        loadAllCoursesFromDB(indicator: true)
        
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
        lblTotal.text = "\(self.courses.count)"
        self.tableView.reloadData()
    }

    @IBAction func btnLeftMenu_Pressed(_ sender: Any) {
        slideMenuController()?.openLeft()
    }

    @IBAction func btnAddNewCourse_Pressed(_ sender: Any) {

        performSegue(withIdentifier: "courseSysToDetailSys", sender: courses)
    }
}

extension CourseListSystemVC: UITableViewDelegate, UITableViewDataSource {

    func setUpTableView() {

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
        
        if editingStyle == .delete {
            
            let alert = AlertController(title: "Alert", message: "Do you want to remove \'\(course.name)\'", preferredStyle: .alert)
            alert.add(AlertAction(title: "Cancel", style: .normal))
            alert.add(AlertAction(title: "Yes", style: .destructive, handler: { alertAction in
                
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
            }))
            alert.present()
        }
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let course = courses[indexPath.row]
        performSegue(withIdentifier: "courseSysToDetailSys", sender: course)
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
