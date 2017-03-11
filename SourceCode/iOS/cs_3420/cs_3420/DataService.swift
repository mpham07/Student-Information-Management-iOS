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
        return main_ref.child(CONSTANTS.users.USERS)
    }
    
    var course_ref: FIRDatabaseReference {
        return main_ref.child(CONSTANTS.courses.COURSES)
    }
    
    var courses_grades: FIRDatabaseReference {
        return user_ref.child(CONSTANTS.courses_grades.COURSES_GRADES)
    }
}

extension DataService {
    
    // ======= COURSES POST METHODS ========
    
    // ADD a course
    func addCourse(uid: String, data: [String: String],_ onComplete: Completion_2?) {
        
        updateCourseInfo(uid: uid, data: data) { (err) in
            onComplete?(err)
        }
    }
    
    // UPDATE info of a course
    func updateCourseInfo(uid: String, data: [String: String], _ onComplete: Completion_2?) {
        
        course_ref.child(uid).updateChildValues(data) { (err, course_ref) in
            onComplete?(err?.localizedDescription)
        }
    }
    
    // DELETE a course ********** TEMP *************
    func deleteCourse(uid: String, _ onComplete: Completion_2?) {
        
        course_ref.child(uid).removeValue { (err, ref) in
            onComplete?(err?.localizedDescription)
        }
    }
}
