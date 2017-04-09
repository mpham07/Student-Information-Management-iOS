//
//  DataService+POST.swift
//  cs_3420
//
//  Created by Minh Pham on 3/11/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataService {

    // ADD a course to Course Lists
    func addNewCourse(uid: String, data: [String: Any],_ onComplete: Completion_And_Err?) {
        
        updateCourseInfo(uid: uid, data: data) { (err) in
            onComplete?(err)
        }
    }
    
    //Add courses for a student
    func addCoursesForStudent(user: User, course: Course , data: Dictionary<String, Any> , _ onComplete: Completion_And_Err?) {
        
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
    
    //ADD an new user ********** uid temperary
    func addNewUser(uid: String, data: [String: Any], _ onComplete: Completion_And_Err?) {
        
        user_ref.child(uid).updateChildValues(data) { (err, ref) in
            onComplete?(err?.localizedDescription)
        }
    }
    
    //STORE pushToken into FirebaseDatabase
    func storePushToken(student: User, tokenString: String, _ onComplete: Completion_And_Err?) {
        
        user_ref.child(student.uid).updateChildValues([CONSTANTS.pushService.TOKEN_STRING: tokenString]) { (err, ref) in
            
            onComplete?(err?.localizedDescription)
        }
    }
}



