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
    // Get only 1 course from DB
    func get_1_course(uid: String?, _ onComplete: Completion?) {
       
        getCourse(uid_parameter: uid) { (error, data) in
            
            onComplete?(error, data)
        }
    }
    
    
    // Get all courses from DB
    func getAllCourses(_ onComplete: Completion?) {
        
        getCourse(uid_parameter: nil) { (error, data) in
            
            onComplete?(error, data)
        }
    }
    
    // General GET function supports about GET COURSE funcs
    private func getCourse (uid_parameter: String?, _ onComplete: Completion?) {
        
        course_ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var courses:[Course]?
            
            // Check if just want to get only 1 course
            if uid_parameter == nil {
                courses = []
            }
            
            for snap in snapshot.children.allObjects as! [FIRDataSnapshot] {
                
                guard let item = snap.value as? [String: String] else {return }
                let uid = snap.key
                
                // Check in function get 1 course, if uid of snap NOT matching
                // the uid parameter then skip loop
                if let uid_p = uid_parameter {
                    if uid != uid_p {
                        continue
                    }
                }
                
                guard let course_id = item[CONSTANTS.courses.COURSE_ID], let name = item[CONSTANTS.courses.NAME], let type = item[CONSTANTS.courses.TYPE] else { return }
                let course = Course(uid: uid, course_id: course_id, name: name, type: type)
                
                if uid_parameter != nil {
                    onComplete?(nil, course)
                    return
                    
                }else {
                    courses?.append(course)
                }
            }
            
            // func get 1 course and, NO any course found
            if uid_parameter != nil {
                onComplete?(CONSTANTS.search.COURSE_NOT_FOUND, nil)
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
    func getAllStudents(_ onComplete: Completion?) {
        
        getUser(filter: CONSTANTS.users.STUDENT, uidParameter: nil) { (error, students) in
            
            onComplete?(error, students)
        }
    }
    
    // Get 1 User matching up with uid
    func get_1_User(uid: String?,_ onComplete: Completion? ) {
        
        getUser(filter: nil, uidParameter: uid) { (error, user) in
            
            onComplete?(error, user)
        }
    }
    
    // General GET function supports about funcs
    private func getUser(filter: String?, uidParameter: String?, _ onComplete: Completion?) {
        
        user_ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot)
            var users: [User]?
            
            // Don't need to instancing users if find 1 user
            if uidParameter == nil {
                users = []
            }
            
            guard snapshot.childrenCount > 0 else { return }
            
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
                
                if let courses_grades = item[CONSTANTS.courses_grades.COURSES_GRADES] as? [Any]{
                    
                    // Check if user is student, then run following block
                    if user.isStudent {
                        
                        var course_grades = [Course_Grade]()
                        for unwrappedItem in courses_grades {
                            if let item = unwrappedItem as? [String: Any] {
                                guard let uid_course = item[CONSTANTS.courses_grades.UID_COURSE] as? String else { return }
                                
                                let course_grade = Course_Grade(uid_course: uid_course);
                                
                                course_grade.assignment = item[CONSTANTS.courses_grades.ASSIGNMENT] as? Int
                                course_grade.final = item[CONSTANTS.courses_grades.FINAL] as? Int
                                course_grade.midterm = item[CONSTANTS.courses_grades.MIDTERM] as? Int
                                course_grade.quiz_1 = item[CONSTANTS.courses_grades.QUIZ_1] as? Int
                                course_grade.quiz_2 = item[CONSTANTS.courses_grades.QUIZ_2] as? Int
                                
                                course_grades.append(course_grade)
                            }
                        }
                        
                        user.course_grades = course_grades
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
                onComplete?(CONSTANTS.search.USER_NOT_FOUND, nil)
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
