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
typealias AnyData = Any?

typealias Completion = ()->Void
typealias Completion_And_Err = (_ errMsg: ErrorMessage) -> Void
typealias Completion_Data_And_Err = (_ errMsg: ErrorMessage, _ data: AnyData) -> Void

class DataService {
    
    private static var _instance = DataService()
    
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
}
