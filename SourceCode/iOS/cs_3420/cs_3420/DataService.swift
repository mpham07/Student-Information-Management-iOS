//
//  DataService.swift
//  cs_3420
//
//  Created by Minh Pham on 3/10/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

typealias Error = String?
typealias Data = Any?
typealias Completion = (_ errMsg: Error, _ data: Data) -> Void

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
