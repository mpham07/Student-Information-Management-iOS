//
//  CourseListSystemVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/18/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

class CourseListSystemVC: UIViewController {
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAllCoursesFromDB()
        setUpTableView()
    }
    
    func loadAllCoursesFromDB() {
        
        self.showProgressLoading()
        
        DataService.instance.getAllCourses { (err, courses) in
            
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
            
            self.dismissProgress()
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
}
