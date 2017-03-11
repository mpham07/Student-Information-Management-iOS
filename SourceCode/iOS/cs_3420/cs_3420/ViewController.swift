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
        
        //get_1_User()
        getUsersFromDB()
        //getCoursesFromDB()
    }
    
    func get_1_User() {
        
        DataService.instance.get_1_User(uid: "nhan_nguyen") { (err, user) in
            
            if let err = err {
                print(err)
                return
            }
            
            self.printU(user: user as! User, 0)
        }
    }
    
    func getUsersFromDB() {
    
        DataService.instance.getAllStudents { (err, students) in
            self.users = students as! [User]
            
            self.printUs(0, 5)
        }
    }
    
    func getCoursesFromDB() {
        
        DataService.instance.getAllCourses { (error, courses) in
            if let err = error {
                print(err)
                return
            }
            
            if let courses = courses as? [Course] {
                self.courses = courses
                //self.printC(num: 2)
            }
        }
    }
    
    func printC(num: Int) {
        print(self.courses[num].uid)
        print(self.courses[num].course_id)
        print(self.courses[num].name)
        print(self.courses[num].type)
        print(self.courses.count)
    }
    
    func printU(user: User, _ course_grade: Int) {
        print(user.email)
        print(user.name)
        print(user.photoUrl)
        print(user.role)
        print(user.student_id)
        
        
        print(user.course_grades?[course_grade].assignment)
        print(user.course_grades?[course_grade].final)
        print(user.course_grades?[course_grade].midterm)
        print(user.course_grades?[course_grade].quiz_1)
        print(user.course_grades?[course_grade].quiz_2)
        print(user.course_grades?[course_grade].uid_course)
    }
    
    func printUs(_ n: Int, _ course_grade: Int) {
        printU(user: users[n], course_grade)
        print(users.count)
    }
}

