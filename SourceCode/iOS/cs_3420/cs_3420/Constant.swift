//
//  Constant.swift
//  cs_3420
//
//  Created by Minh Pham on 3/10/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation

struct CONSTANTS {
    
    struct courses {
        
        static let UID = "courses"
        static let COURSE_ID = "course_id"
        static let NAME = "name"
        static let TYPE = "type"
        static let REGISTERED = "registered"
        
        static let IN_CLASS = "in_class"
        static let HYBRID = "hybrid"
        static let ONLINE = "online"
    }
    
    struct users {
        static let ADMIN = "admin"
        static let STUDENT = "student"
        
        static let UID = "users"
        static let EMAIL = "email"
        static let NAME = "name"
        static let PHOTO_URL = "photoUrl"
        static let ROLE = "role"
        static let STUDENT_ID = "student_id"
    }
    
    struct courses_grades {
        
        static let UID = "courses_grades"
        static let ASSIGNMENT = "assigment"
        static let FINAL = "final"
        static let MIDTERM = "midterm"
        static let QUIZ_1 = "quiz_1"
        static let QUIZ_2 = "quiz_2"
        static let UID_COURSE = "uid_course"
    }
    
    struct search {
        static let USER_NOT_FOUND = "The user is not found!"
        static let COURSE_NOT_FOUND = "The course not found!"
    }
}
