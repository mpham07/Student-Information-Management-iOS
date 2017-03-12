//
//  DataService+DELETE.swift
//  cs_3420
//
//  Created by Minh Pham on 3/11/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation

extension DataService {
    
    //Remove courses for a student
    func deleteCoursesForStudent(user: User, course: Course, _ onComplete: Completion_And_Err?) {
        
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
    
    // DELETE a course from Course Lists ********** TEMP *************
    func deleteCourse(uid: String, _ onComplete: Completion_And_Err?) {
        
        course_ref.child(uid).removeValue { (err, ref) in
            onComplete?(err?.localizedDescription)
        }
    }
}
