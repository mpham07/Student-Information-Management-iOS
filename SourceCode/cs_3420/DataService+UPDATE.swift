//
//  DataService+UPDATE.swift
//  cs_3420
//
//  Created by Minh Pham on 3/11/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation

extension DataService {
    
    // UPDATE info of a course from Course Lists
    func updateCourseInfo(uid: String, data: [String: Any], _ onComplete: Completion_And_Err?) {
        
        course_ref.child(uid).updateChildValues(data) { (err, course_ref) in
            onComplete?(err?.localizedDescription)
        }
    }
    
    // UPDATE grades of a course_grade
    func updateGradesOfACourse(user_uid: String, course_uid: String, data: [String: Any], _ onComplete: Completion_And_Err?) {
        
        let ref = user_ref.child(user_uid).child(CONSTANTS.courses_grades.UID).child(course_uid)
        ref.updateChildValues(data) { (err, ref) in
            onComplete?(err?.localizedDescription)
        }
    }
    
    //UPDATE An user info
    func updateAUserInfo(user: User, data: [String: Any], _ onComplete: Completion_And_Err?) {
        
        let ref = user_ref.child(user.uid)
        ref.updateChildValues(data) { (err, ref) in
            
            onComplete?(err?.localizedDescription)
        }
    }
}
