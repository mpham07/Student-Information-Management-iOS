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
    
    init(uid: String, course_id: String, name: String, type: String) {
        _uid = uid
        _course_id = course_id
        _name = name
        _type = type
    }
}
