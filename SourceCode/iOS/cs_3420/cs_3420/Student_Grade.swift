//
//  Student_Courses.swift
//  cs_3420
//
//  Created by Minh Pham on 3/9/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation

class Student_Grade {
    
    private var _uid_course: String
    private var _assignment: Int
    private var _final: Int
    private var _midterm: Int
    private var _quiz_1: Int
    private var _quiz_2: Int
    
    var uid_course: String {
        return _uid_course
    }
    
    var assignment: Int {
        return _assignment
    }
    
    var final: Int {
        return _final
    }
    
    var midterm: Int {
        return _midterm
    }
    
    var quiz_1: Int {
        return _quiz_1
    }
    
    var quiz_2: Int {
        return _quiz_2
    }
    
    init(uid_course: String, assignment: Int, quiz_1: Int, quiz_2: Int, midterm: Int, final: Int) {
        _uid_course = uid_course
        _assignment = assignment
        _quiz_1 = quiz_1
        _quiz_2 = quiz_2
        _midterm = midterm
        _final = final
    }
}
