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
    private var _course_grades: [Student_Grade]?
    
    var uid: String {
        return _uid
    }
    
    var email: String {
        return _email
    }
    
    var name: String {
        return _name
    }
    
    var photoUrl: String? {
        return _photoUrl
    }
    
    var role: String {
        return _role
    }
    
    var student_id: String? {
        return _student_id
    }
    
    var course_grades: [Student_Grade]? {
        return _course_grades
    }
    
    init(uid: String, email: String, name: String, photoUrl: String?, role: String, student_id: String?, course_grades: [Student_Grade]?) {
        _uid = uid
        _email = email
        _name = name
        _photoUrl = photoUrl
        _role = role
        _student_id = student_id
        _course_grades = course_grades
    }
}
