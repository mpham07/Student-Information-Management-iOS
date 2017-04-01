//
//  Constant.swift
//  cs_3420
//
//  Created by Minh Pham on 3/10/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation
import UIKit

struct CONSTANTS {
    // Structs Only
    
    struct courses {

        static let UID = "courses"
        static let COURSE_ID = "course_id"
        static let NAME = "name"
        static let TYPE = "type"
        static let REGISTERED = "registered"

        static let IN_CLASS = "In Person"
        static let HYBRID = "Hybrid"
        static let ONLINE = "Online"
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
        static let MAJOR = "major"
    }
    
    struct storage {
        
        static let MAIN_PATH = "gs://pokesearch-ef252.appspot.com/"
        static let STORAGE_PROFILE_IMAGES = "profile_images"
    }

    struct courses_grades {

        static let UID = "courses_grades"
        static let ASSIGNMENT = keyOfGrades.ASSIGNMENT.rawValue
        static let FINAL = keyOfGrades.FINAL.rawValue
        static let MIDTERM = keyOfGrades.MIDTERM.rawValue
        static let QUIZ_1 = keyOfGrades.QUIZ_1.rawValue
        static let QUIZ_2 = keyOfGrades.QUIZ_2.rawValue
        static let UID_COURSE = "uid_course"

        static let NONE_AVERAGE = "N/A"
        static let DEFAULT_GRADE = -1
        static let MAX_GRADE = 100
        static let MIN_GRADE = 0
    }

    struct notices {
        static let USER_NOT_FOUND = "The user is not found!"
        static let COURSE_NOT_FOUND = "The course not found!"
        static let COURSE_BEING_ENROLLED = "This course is currently registered by students!"
    }
    
    struct statusOfGrades {
        static let GRADED = "Graded"
        static let IN_COMNG = "In coming"
    }

    struct imagesAssets {

        static let PROFILE_DEFAULT = "PROFILE_DEFAULT"
    }

    struct indicatorMessage {

        static let LOADING = "Loading..."
        static let UPDATING = "Updating..."
        static let DELETING = "Deleting..."
    }
}

extension CONSTANTS {
    // Enums Only
    
    enum nameOfGrades: String {
        case ASSIGNMENT = "Assigment"
        case QUIZ_1 = "Quiz 1"
        case QUIZ_2 = "Quiz 2"
        case MIDTERM = "Midterm"
        case FINAL = "Final"
    }
    
    enum keyOfGrades: String {
        case ASSIGNMENT = "assigment"
        case FINAL = "final"
        case MIDTERM = "midterm"
        case QUIZ_1 = "quiz_1"
        case QUIZ_2 = "quiz_2"
    }
    
    enum gradeLetter: String {
        
        case A = "A"
        case B = "B"
        case C = "C"
        case D = "D"
        case F = "F"
    }
    
    enum valueOfGradeLetter: Double {
        case A = 4.0
        case B = 3.0
        case C = 2.0
        case D = 1.0
        case F = 0.0
    }
    
    enum menuItems: String {
        
        case PROFILE = "PROFILE"
        case COURSES = "COURSES"
        case NOTIFICATION = "NOTIFICATION"
        case LOGOUT = "LOG OUT"
        case STUDENTS = "STUDENTS"
    }
}


