//
//  User.swift
//  cs_3420
//
//  Created by Minh Pham on 3/9/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation

class User {
    
    private var _uid: String
    private var _email: String
    private var _name: String
    private var _photoUrl: String?
    private var _role: String
    private var _student_id: String?
    private var _course_grades: [Course_Grade]?
    
    var uid: String {
        return _uid
    }
    
    var email: String {
        return _email
    }
    
    var name: String {
        return _name
    }
    
    var role: String {
        return _role
    }
    
    var photoUrl: String? {
        get {
            return _photoUrl
        }
        set {
            _photoUrl = newValue
        }
    }
    
    var student_id: String? {
        get {
            return _student_id
        }
        set {
            _student_id = newValue
        }
    }
    
    var course_grades: [Course_Grade]? {
        get {
            return _course_grades
        }
        set {
            _course_grades = newValue
        }
    }
    
    var isAdmin: Bool {
        
        if _role == CONSTANTS.users.ADMIN {
            return true
        }
        
        return false
    }
    
    var isStudent: Bool {
        
        return !isAdmin
    }
    
    var GPA: String {
        
        if let grades = _course_grades {
            
            var sum = 0.0
            for grade in grades {
                if let val = grade.valueOfGradeLetter {
                    sum += val.rawValue
                }
            }
            
            let gpa = sum / Double(grades.count)
            
            return "\(gpa)"
        }
        
        return "0"
    }
    
    var takingCourses: String {
        
        if let grades = _course_grades {
            return "\(grades.count)"
        }
        
        return ""
    }
    
    init(uid: String, email: String, name: String, role: String) {
        _uid = uid
        _email = email
        _name = name
        _role = role
    }
}
