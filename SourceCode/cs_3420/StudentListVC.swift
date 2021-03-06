//
//  StudentListVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/18/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

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
        //showProgress(type: .LOADING, userInteractionEnable: true)
        DataService.instance.getAllStudents { (err, students) in
            //self.dismissProgress()
            
            if let err = err {
                
                Libs.showAlertView(title: nil, message: err, cancelComplete: nil)
                return
            }

            // Seccessully got all data
            if let studentList = students as? [User] {

                self.students = studentList
                self.loadUI()
            }
        }
    }
}

// Take care of UI events
extension StudentListVC {
   
    @IBAction func btnOpenRightMenu(_ sender: Any) {
        performSegue(withIdentifier: "segStudentListVCToNewStudentVC", sender: nil)
    }
    
    @IBAction func btnOpenLeftMenu(_ sender: Any) {

        self.navigationController?.slideMenuController()?.openLeft()
    }

    func loadUI() {
        lblTotal.text = "\(students.count)"
        self.tableView.reloadData()
    }
}

extension StudentListVC: UITableViewDelegate, UITableViewDataSource, StudentCellDelegate {

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
            cell.delegate = self
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
        } else if let vc = segue.destination as? ProfileVC {
            if let student = sender as? User {
                
                vc.student = student
            }
        }
    }

    func imageProfile_Pressed(cell: StudentCell) {

        //studentVCToProfileVC
        if let indexPath = tableView.indexPath(for: cell) {
            let student = students[indexPath.row]
            performSegue(withIdentifier: "studentVCToProfileVC", sender: student)

        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let student = students[indexPath.row]
        
        if editingStyle == .delete {
            
            // To do something
            Libs.showAlertView(title: nil, message: "Do you want to DELETE '\(student.name)'", actionCompletion: { 
                self.showProgress(type: .DELETING, userInteractionEnable: false)
                AuthService.instance.deleteAStudent(user: student, { (err) in
                    self.dismissProgress()
                    if let err = err {
                        
                        print(err)
                        return
                    }
                    
                    // Sucessfully Delete
                    self.students.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                })

            }, cancelCompletion: nil)
        }
    }
}
