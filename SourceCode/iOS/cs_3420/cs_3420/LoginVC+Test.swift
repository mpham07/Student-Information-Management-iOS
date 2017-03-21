//
//  LoginVC+Test.swift
//  cs_3420
//
//  Created by Minh Pham on 3/14/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation

// Test Login VC
extension LoginVC {
    
    func setupViewDidLoad() {
        //get_1_course()
        //getCoursesFromDB()
        
        //get_1_User()
        getAllStudentsFromDB()
        
        //addCoursesIntoAStudent()
    }
    
    func deleteCoursesOfAStudent() {
        let user = self.users[0]
        //let arrCourses = [self.courses[0], self.courses[1]]
        let arrCourses = [self.courses[0]]
        for cou in arrCourses {
            DataService.instance.deleteCoursesForStudent(user: user, course: cou, { (err) in
                
                print("Delete a \(cou.course_id) for Student successfully")
            })
        }
    }
    
    func addNewStudent() {
        
        let uid = "nhan_nguyen"
        
        let info = [
            CONSTANTS.users.EMAIL: "nhan@gmail.com",
            CONSTANTS.users.NAME: "Nhan Nguyen",
            CONSTANTS.users.ROLE: CONSTANTS.users.STUDENT,
            CONSTANTS.users.STUDENT_ID: "988733222"
        ]
        
        DataService.instance.addNewUser(uid: uid, data: info) { (err) in
            print("ADDED user info successfully")
        }
    }
    
    func updateUserInfo() {
        let user = self.users[2]
        
        var info = [CONSTANTS.users.NAME: "Lalala",]
        
        if user.isStudent {
            info[CONSTANTS.users.STUDENT_ID] = "223344244"
        }
        
        DataService.instance.updateAUserInfo(user: user, data: info) { (err) in
            print("UPDATED user info successfully")
        }
    }
    
//    func updateGradesOfACourse1() {
//        
//        let user = self.users[0]
//        let course = self.courses[0]
//        let dict = [CONSTANTS.courses_grades.ASSIGNMENT: 80,
//                    CONSTANTS.courses_grades.FINAL: 30,
//                    CONSTANTS.courses_grades.MIDTERM: CONSTANTS.courses_grades.DEFAULT_GRADE,
//                    CONSTANTS.courses_grades.QUIZ_1: 100,
//                    CONSTANTS.courses_grades.QUIZ_2: CONSTANTS.courses_grades.DEFAULT_GRADE]
//        
//        DataService.instance.updateGradesOfACourse(user_uid: user, course_uid: "fsf", data: dict) { (err) in
//            
//            print("Update Grades of \(user.name) and course \(course.name)")
//        }
//    }
    
    func addCoursesIntoAStudent() {
        
        let user = self.users[0]
        //let arrCourses = [self.courses[0], self.courses[1]]
        let arrCourses = [self.courses[0]]
        let dict = [CONSTANTS.courses_grades.ASSIGNMENT: CONSTANTS.courses_grades.DEFAULT_GRADE,
                    CONSTANTS.courses_grades.FINAL: CONSTANTS.courses_grades.DEFAULT_GRADE,
                    CONSTANTS.courses_grades.MIDTERM: CONSTANTS.courses_grades.DEFAULT_GRADE,
                    CONSTANTS.courses_grades.QUIZ_1: CONSTANTS.courses_grades.DEFAULT_GRADE,
                    CONSTANTS.courses_grades.QUIZ_2: CONSTANTS.courses_grades.DEFAULT_GRADE]
        
        for cou in arrCourses {
            DataService.instance.addCoursesForStudent(user: user, course: cou, data: dict) { (err) in
                
                print("Added a \(cou.course_id) for Student successfully")
            }
        }
    }
    
    func deleteCourse() {
        //let uid = "COMM_1301"
        
        let course = courses[2]
        if course.enrolled == 0 {
            DataService.instance.deleteCourse(course: course) { (err) in
                print("Deleted course successfully")
            }
        }else {
            print("This course is currently registered by students!")
        }
    }
    
    func updateCourse() {
        
        let course: [String: Any] = [
            CONSTANTS.courses.COURSE_ID: "COMM 1302",
            CONSTANTS.courses.NAME: "Intro to Communication",
            CONSTANTS.courses.TYPE: CONSTANTS.courses.ONLINE,
            CONSTANTS.courses.REGISTERED: 0
        ]
        
        let uid = "COMM_1301"
        
        DataService.instance.updateCourseInfo(uid: uid, data: course) { (err) in
            
            print("Update course successfully")
        }
    }
    
    func addCourse() {
        
        let course_id = "COMM 1301";
        let course: [String : Any] = [
            CONSTANTS.courses.COURSE_ID: course_id,
            CONSTANTS.courses.NAME: "Communication 1",
            CONSTANTS.courses.TYPE: CONSTANTS.courses.HYBRID,
            CONSTANTS.courses.REGISTERED: 0
        ]
        
        let uid = course_id.replacingOccurrences(of: " ", with: "_")
        
        DataService.instance.addNewCourse(uid: uid, data: course) { (err) in
            print("Added course successfully")
        }
    }
    
    
//    func getCoursesFromDB() {
//        
//        DataService.instance.getAllCourses { (err, courses) in
//            
//            if let err = err {
//                print(err)
//                return
//            }
//            
//            if let courses = courses as? [Course] {
//                self.courses = courses
//                //self.printC(num: 2)
//            }
//        }
//    }
    
    func get_1_course() {
        
        DataService.instance.getACourseInfo(uid: "CS_3308") { (err, course) in
            
            if let err = err {
                print(err)
                return
            }
            
            if let course = course {
                self.print_1C(course: course as! Course)
            }
        }
    }
    
    func get_1_User(uid: String) {
        
        DataService.instance.getAUser(uid: uid) { (err, user) in
            
            if let err = err {
                print(err)
                return
            }
            
            //self.printU(user: user as! User, 0)
        }
    }
    
    func getAllStudentsFromDB() {
        
        DataService.instance.getAllStudents { (err, students) in
            if let err = err {
                print(err)
                return
            }
            self.users = students as! [User]
            
            //print(self.users[0].course_grades?[0].averge)
            self.printUs(0, 0)
        }
    }
    
    //
    func printC(num: Int) {
        print_1C(course: courses[num])
    }
    
    func print_1C(course: Course) {
        print(course.uid)
        print(course.course_id)
        print(course.name)
        print(course.type)
        print(course.enrolled)
    }
    
    func printU(user: User, _ course_grade: Int) {
        print(user.email)
        print(user.name)
        print(user.photoUrl!)
        print(user.role)
        print(user.student_id!)
        
        
//        print(user.course_grades?[course_grade].assignment!)
//        print(user.course_grades?[course_grade].final!)
//        print(user.course_grades?[course_grade].midterm!)
//        print(user.course_grades?[course_grade].quiz_1!)
//        print(user.course_grades?[course_grade].quiz_2!)
//        print(user.course_grades?[course_grade].uid_course)
    }
    
    func printUs(_ n: Int, _ course_grade: Int) {
        printU(user: users[n], course_grade)
        print(users.count)
    }
}

