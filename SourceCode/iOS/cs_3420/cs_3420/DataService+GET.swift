//
//  DataService+GET.swift
//  cs_3420
//
//  Created by Minh Pham on 3/11/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataService {
    
    // ======= COURSES GET METHODS ========
    
    // Get all courses of a student
    func getCoursesOfAStudent(user: User, _ onComplete: Completion_Data_And_Err?) {
        
//        if let user = AppState.instance.user {
//            if let coursesList = user.course_grades {
//                courses = coursesList
//                
//                for course in courses! {
//                    DataService.instance.getACourseInfo(uid: course.uid_course, { (err, courseInfo) in
//                        
//                        if let err = err {
//                            print (err)
//                            return
//                        }
//                        
//                        // Successfully get course info
//                        if let courseInfo = courseInfo as? Course {
//                            course.courseInfo = courseInfo
//                            
//                            self.tableView.reloadData()
//                        }
//                    })
//                }
//            }
//        }
        
        if let coursesList = user.course_grades {
            
            for course in coursesList {
                getACourseInfo(uid: course.uid_course, { (err, courseInfo) in
                    
                    if let err = err {
                        onComplete?(err, nil)
                        return
                    }
                    
                    course.courseInfo = courseInfo as? Course
                })
            }
        }
    }
    
    // Get only 1 course from DB
    func getACourseInfo(uid: String?, _ onComplete: Completion_Data_And_Err?) {
        
        getCourse(uid_parameter: uid) { (error, data) in
            
            onComplete?(error, data)
        }
    }
    
    // Get all courses from DB
    func getAllCourses(_ onComplete: Completion_Data_And_Err?) {
        
        getCourse(uid_parameter: nil) { (error, data) in
            
            onComplete?(error, data)
        }
    }
    
    // General GET function supports about GET COURSE funcs
    private func getCourse (uid_parameter: String?, _ onComplete: Completion_Data_And_Err?) {
        
        course_ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var courses:[Course]?
            
            // Check if just want to get only 1 course
            if uid_parameter == nil {
                courses = []
            }
            
            for snap in snapshot.children.allObjects as! [FIRDataSnapshot] {
                
                guard let item = snap.value as? [String: Any] else {return }
                let uid = snap.key
                
                // Check in function get 1 course, if uid of snap NOT matching
                // the uid parameter then skip loop
                if let uid_p = uid_parameter {
                    if uid != uid_p {
                        continue
                    }
                }
                
                guard let course_id = item[CONSTANTS.courses.COURSE_ID] as? String, let name = item[CONSTANTS.courses.NAME] as? String, let type = item[CONSTANTS.courses.TYPE] as? String, let registed = item[CONSTANTS.courses.REGISTERED] as? Int else { return }
                
                let course = Course(uid: uid, course_id: course_id, name: name, type: type, registed: registed)
                
                // Check if want to get 1 course
                if uid_parameter != nil {
                    onComplete?(nil, course)
                    return
                    
                }else {
                    courses?.append(course)
                }
            }
            
            // func get 1 course and, NO any course found
            if uid_parameter != nil {
                onComplete?(CONSTANTS.notices.COURSE_NOT_FOUND, nil)
                return
            }else {
                
                // func get all courses
                onComplete?(nil, courses)
            }
            
        }) { (error) in
            onComplete?(error.localizedDescription, nil)
        }
    }
    
    // =========== USERS GET METHOD ===========
    // Get All Students
    func getAllStudents(_ onComplete: Completion_Data_And_Err?) {
        
        getUser(filter: CONSTANTS.users.STUDENT, uidParameter: nil) { (error, students) in

            onComplete?(error, students)
        }
    }
    
    // Get 1 User matching up with uid
    func getAUser(uid: String?,_ onComplete: Completion_Data_And_Err? ) {
        
        getUser(filter: nil, uidParameter: uid) { (error, user) in
            
            onComplete?(error, user)
        }
    }
    
    // General GET function supports about funcs
    private func getUser(filter: String?, uidParameter: String?, _ onComplete: Completion_Data_And_Err?) {
        
        user_ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot)
            var users: [User]?
            
            // Don't need to instancing users if find 1 user
            if uidParameter == nil {
                users = []
            }
            
            for snap in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let uid = snap.key
    
                guard let item = snap.value as? [String: Any] else { return }
                guard let email = item[CONSTANTS.users.EMAIL] as? String,
                    let name = item[CONSTANTS.users.NAME] as? String,
                    let role = item[CONSTANTS.users.ROLE] as? String
                    else { return }
                
                let user = User(uid: uid, email: email, name: name, role: role)
                
                // Check filter Student or Admin
                if let filter = filter {
                    if user.role != filter { continue }
                }
                
                if let photoUrl = item[CONSTANTS.users.PHOTO_URL] as? String {
                    user.photoUrl = photoUrl
                }
                
                if let student_id = item[CONSTANTS.users.STUDENT_ID] as? String {
                    user.student_id = student_id
                }
                
                if let courses_grades = item[CONSTANTS.courses_grades.UID] as? [String:Any]{
                    // Check if user is student, then run following block
                    if user.isStudent {
                        
                        var grades = [Course_Grade]()
                        for (key, dict) in courses_grades {
                            let course_grade = Course_Grade(uid_course: key)
                            
                            if let value = dict as? [String: Int] {
                                course_grade.assignment = value[CONSTANTS.courses_grades.ASSIGNMENT]
                                course_grade.final = value[CONSTANTS.courses_grades.FINAL]
                                course_grade.midterm = value[CONSTANTS.courses_grades.MIDTERM]
                                course_grade.quiz_1 = value[CONSTANTS.courses_grades.QUIZ_1]
                                course_grade.quiz_2 = value[CONSTANTS.courses_grades.QUIZ_2]
                            }
                        
                            grades.append(course_grade)
                            
                        }
                        
                        user.course_grades = grades
                    }
                }
                
                // Get only 1 user
                if let uidParameter = uidParameter, user.uid == uidParameter {
                    
                    onComplete?(nil, user)
                    return
                    
                }else {
                    
                    // func get 1 user so don't need users?.append
                    users?.append(user)
                }
            }
            
            // func get 1 user, and no user found
            if uidParameter != nil {
                onComplete?(CONSTANTS.notices.USER_NOT_FOUND, nil)
                return
                
            } else {
                //func get all users
                onComplete?(nil, users)
            }
        }) { (error) in
            
            onComplete?(error.localizedDescription, nil)
        }
    }
}
