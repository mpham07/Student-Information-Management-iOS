//
//  Student_Courses.swift
//  cs_3420
//
//  Created by Minh Pham on 3/9/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation

class Course_Grade {
    
    private var _uid_course: String
    private var _assignment: Int?
    private var _final: Int?
    private var _midterm: Int?
    private var _quiz_1: Int?
    private var _quiz_2: Int?
    
    var uid_course: String {
        get {
            return _uid_course
        }
        set{
            _uid_course = newValue
        }
    }
    
    var assignment: Int? {
        get {
            return _assignment
        }
        set{
            _assignment = newValue
        }
    }
    
    var final: Int? {
        get {
            return _final
        }
        set{
            _final = newValue
        }
        
    }
    
    var midterm: Int? {
        get {
           return _midterm
        }
        set{
            _midterm = newValue
        }
    }
    
    var quiz_1: Int? {
        get {
           return _quiz_1
        }
        set{
            _quiz_1 = newValue
        }
        
    }
    
    var quiz_2: Int? {
        get {
            return _quiz_2
        }
        set{
            _quiz_2 = newValue
        }
    }
    
//    init(uid_course: String?, assignment: Int?, quiz_1: Int?, quiz_2: Int?, midterm: Int?, final: Int?) {
//        _uid_course = uid_course
//        _assignment = assignment
//        _quiz_1 = quiz_1
//        _quiz_2 = quiz_2
//        _midterm = midterm
//        _final = final
//    }
    
    init(uid_course: String) {
        _uid_course = uid_course
    }
}
