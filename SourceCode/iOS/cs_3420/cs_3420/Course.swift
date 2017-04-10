//
//  Course.swift
//  cs_3420
//
//  Created by Minh Pham on 3/9/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation



class Course {
    
    private var _uid: String
    private var _course_id: String
    private var _name: String
    private var _type: String
    private var _registed: Int
    
    var incrementRegisted: Int {
        get {
            _registed += 1
            return _registed
        }
    }
    
    var decrementRegisted: Int {
        get {
            _registed -= 1
            return _registed
        }
    }
    
    var enrolled: Int {
        return _registed
    }
    
    var uid: String {
        return _uid
    }
    
    var course_id: String {
        return _course_id
    }
    
    var name: String {
        return _name
    }
    
    var type: String {
        return _type
    }
    
    init(uid: String, course_id: String, name: String, type: String, registed: Int) {
        _uid = uid
        _course_id = course_id
        _name = name
        _type = type
        _registed = registed
    }
    
    func updateInfo(course_id: String, name: String, type: String) {
        
        _course_id = course_id
        _name = name
        _type = type
    }
}
