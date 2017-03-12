//
//  DataService.swift
//  cs_3420
//
//  Created by Minh Pham on 3/10/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

typealias ErrorMessage = String?
typealias Data = Any?

typealias Completion_2 = (_ errMsg: ErrorMessage) -> Void
typealias Completion = (_ errMsg: ErrorMessage, _ data: Data) -> Void

class DataService {
    
    private static var _instance = DataService();
    
    static var instance: DataService {
        return _instance
    }
    
    var main_ref: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var user_ref: FIRDatabaseReference {
        return main_ref.child(CONSTANTS.users.UID)
    }
    
    var course_ref: FIRDatabaseReference {
        return main_ref.child(CONSTANTS.courses.UID)
    }
    
    var courses_grades: FIRDatabaseReference {
        return user_ref.child(CONSTANTS.courses_grades.UID)
    }
}

extension DataService {
    
    // ======= COURSES POST METHODS ========
    
    // COURSE LISTS
    // ADD a course to Course Lists
    func addCourse(uid: String, data: [String: Any],_ onComplete: Completion_2?) {
        
        updateCourseInfo(uid: uid, data: data) { (err) in
            onComplete?(err)
        }
    }
    
    // UPDATE info of a course from Course Lists
    func updateCourseInfo(uid: String, data: [String: Any], _ onComplete: Completion_2?) {
        
        course_ref.child(uid).updateChildValues(data) { (err, course_ref) in
            onComplete?(err?.localizedDescription)
        }
    }
    
    // DELETE a course from Course Lists ********** TEMP *************
    func deleteCourse(uid: String, _ onComplete: Completion_2?) {
        
        course_ref.child(uid).removeValue { (err, ref) in
            onComplete?(err?.localizedDescription)
        }
    }
    
    
    //COURSE FOR STUDENTS
    //Add courses for a student
    func addCoursesForStudent(user: User, course: Course , data: Dictionary<String, Any> , _ onComplete: Completion_2?) {
        
        let ref = user_ref.child(user.uid).child(CONSTANTS.courses_grades.UID).child(course.uid)
    
        ref.updateChildValues(data) { (err, ref) in
            if err != nil {
                onComplete?(err?.localizedDescription)
                return
            }
            
            self.updateCourseInfo(uid: course.uid, data: [CONSTANTS.courses.REGISTERED: course.incrementRegisted], { (error) in
                onComplete?(error)
            })
        }
    }
    
    //Remove courses for a student
    func deleteCoursesForStudent(user: User, course: Course, _ onComplete: Completion_2?) {
        
        let ref = user_ref.child(user.uid).child(CONSTANTS.courses_grades.UID).child(course.uid)
        
        ref.removeValue { (err, ref) in
            
            if err != nil {
                onComplete?(err?.localizedDescription)
                return
            }
            
             self.updateCourseInfo(uid: course.uid, data: [CONSTANTS.courses.REGISTERED: course.decrementRegisted], { (error) in
                
                onComplete?(error)
            })
        }
    }
}
