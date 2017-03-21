//
//  StudentListVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/18/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import FTIndicator

class StudentListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    
    var students = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAllStudentsData()
    }
    
    func loadAllStudentsData() {
        
        //self.showProgressLoading()
        DataService.instance.getAllStudents { (err, students) in
            
            if let err = err {
                
                self.showError(err: err)
                return
            }
            
            // Seccessully got all data
            if let studentList = students as? [User] {
                
                //self.dismissProgress()
                FTIndicator.dismissProgress()
                self.students = studentList
                self.loadUI()
            }
        }
    }
}

// Take care of UI events
extension StudentListVC {
    
    @IBAction func btnOpenLeftMenu(_ sender: Any) {
        
        self.navigationController?.slideMenuController()?.openLeft()
    }
    
    func loadUI() {
        lblTotal.text = "\(students.count)"
        self.tableView.reloadData()
    }
}

extension StudentListVC: UITableViewDelegate, UITableViewDataSource {
    
    func setUpTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as? StudentCell {
            
            let student = students[indexPath.row]
            cell.updateUI(student: student)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = students[indexPath.row]
        performSegue(withIdentifier: "studentListToCourseList", sender: student)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? CourseListVC {
            if let student = sender as? User {
                vc.student = student
            }
        }
    }
}
