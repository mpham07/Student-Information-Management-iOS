//
//  ViewController.swift
//  cs_3420
//
//  Created by Minh Pham on 3/9/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    var courses = [Course]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsersFromDB()
        getCoursesFromDB()
    }
    
    func getUsersFromDB() {
    
        let ref = FIRDatabase.database().reference().child(CONSTANTS.users.users)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard snapshot.childrenCount > 0 else { return }
            for snap in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let uid = snap.key
                
                guard let item = snap.value as? [String: Any] else { return }
                guard let email = item[CONSTANTS.users.email] as? String,
                      let name = item[CONSTANTS.users.name] as? String,
                      let role = item[CONSTANTS.users.role] as? String
                else { return }
                
                let user = User(uid: uid, email: email, name: name, role: role)
                
                if let photoUrl = item[CONSTANTS.users.photoUrl] as? String {
                    user.photoUrl = photoUrl
                }
                
                if let student_id = item[CONSTANTS.users.student_id] as? String {
                    user.student_id = student_id
                }
                
                if let courses_grades = item[CONSTANTS.courses_grades.courses_grades] as? [Any]{
                    
                    var course_grades = [Course_Grade]()
                    for unwrappedItem in courses_grades {
                        if let item = unwrappedItem as? [String: Any] {
                            guard let uid_course = item[CONSTANTS.courses_grades.uid_course] as? String else { return }
                            
                            let course_grade = Course_Grade(uid_course: uid_course);
                            
                            course_grade.assignment = item[CONSTANTS.courses_grades.assignment] as? Int
                            course_grade.final = item[CONSTANTS.courses_grades.final] as? Int
                            course_grade.midterm = item[CONSTANTS.courses_grades.midterm] as? Int
                            course_grade.quiz_1 = item[CONSTANTS.courses_grades.quiz_1] as? Int
                            course_grade.quiz_2 = item[CONSTANTS.courses_grades.quiz_2] as? Int
                            
                            course_grades.append(course_grade)
                        }
                    }
                    user.course_grades = course_grades
                }
                
                self.users.append(user)
            }
            
            self.printp(2,3)
        }, withCancel: nil)
    }
    
    func printp(_ user: Int, _ course_grade: Int) {
        print(self.users[user].email)
        print(self.users[user].name)
        print(self.users[user].photoUrl)
        print(self.users[user].role)
        print(self.users[user].student_id)
        
        
        print(self.users[user].course_grades?[course_grade].assignment)
        print(self.users[user].course_grades?[course_grade].final)
        print(self.users[user].course_grades?[course_grade].midterm)
        print(self.users[user].course_grades?[course_grade].quiz_1)
        print(self.users[user].course_grades?[course_grade].quiz_2)
        print(self.users[user].course_grades?[course_grade].uid_course)
    }
    
    func getCoursesFromDB() {
        
        let ref = FIRDatabase.database().reference().child(CONSTANTS.courses.courses)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for snap in snapshot.children.allObjects as! [FIRDataSnapshot] {
                
                guard let item = snap.value as? [String: String] else {return }
                let uid = snap.key
                
                guard let course_id = item[CONSTANTS.courses.course_id], let name = item[CONSTANTS.courses.name], let type = item[CONSTANTS.courses.type] else { return }
                let course = Course(uid: uid, course_id: course_id, name: name, type: type)
                self.courses.append(course)
            }
            
            //            print(self.courses[2].uid)
            //            print(self.courses[2].course_id)
            //            print(self.courses[2].name)
            //            print(self.courses[2].type)
            //            print(self.courses.count)
        }, withCancel: nil)

    }
}

