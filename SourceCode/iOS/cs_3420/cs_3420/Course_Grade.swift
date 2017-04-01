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

    private var _courseInfo: Course?
    private var _student_uid: String?

    var student_uid: String? {

        set {
            _student_uid = newValue
        }
        get {
            return _student_uid
        }
    }

    var courseInfo: Course? {
        get {
            return _courseInfo
        }
        set {
            _courseInfo = newValue
        }
    }

    var averge: Int? {

        var sum = 0
        var count = 0

        if let assign = _assignment, assign >= 0 {
            sum += assign
            count += 1
        }

        if let final = _final, final >= 0 {
            sum += final
            count += 1
        }

        if let midterm = _midterm, midterm >= 0 {
            sum += midterm
            count += 1
        }

        if let quiz_1 = _quiz_1, quiz_1 >= 0 {
            sum += quiz_1
            count += 1
        }

        if let quiz_2 = _quiz_2, quiz_2 >= 0 {
            sum += quiz_2
            count += 1
        }

        if sum != 0 {
            return sum / count
        }

        return nil
    }

    var uid_course: String {
        get {
            return _uid_course
        }
        set {
            _uid_course = newValue
        }
    }

    var assignment: Int? {
        get {
            return _assignment
        }
        set {
            _assignment = newValue
        }
    }

    var final: Int? {
        get {
            return _final
        }
        set {
            _final = newValue
        }

    }

    var midterm: Int? {
        get {
            return _midterm
        }
        set {
            _midterm = newValue
        }
    }

    var quiz_1: Int? {
        get {
            return _quiz_1
        }
        set {
            _quiz_1 = newValue
        }

    }

    var quiz_2: Int? {
        get {
            return _quiz_2
        }
        set {
            _quiz_2 = newValue
        }
    }

    var gradeLetter: CONSTANTS.gradeLetter? {

        if let averge = self.averge {
            switch averge {
            case 90...100:
                return CONSTANTS.gradeLetter.A
            case 80...89:
                return CONSTANTS.gradeLetter.B
            case 70...79:
                return CONSTANTS.gradeLetter.C
            case 60...69:
                return CONSTANTS.gradeLetter.D
            default:
                return CONSTANTS.gradeLetter.F
            }
        }

        return nil
    }

    var valueOfGradeLetter: CONSTANTS.valueOfGradeLetter? {

        if let gradeLetter = gradeLetter {
            switch gradeLetter {
            case CONSTANTS.gradeLetter.A:
                return CONSTANTS.valueOfGradeLetter.A
            case CONSTANTS.gradeLetter.B:
                return CONSTANTS.valueOfGradeLetter.B
            case CONSTANTS.gradeLetter.C:
                return CONSTANTS.valueOfGradeLetter.C
            case CONSTANTS.gradeLetter.D:
                return CONSTANTS.valueOfGradeLetter.D
            default:
                return CONSTANTS.valueOfGradeLetter.F
            }
        }

        return nil
    }

//    var creditHour: Int {
//
//        var str = _uid_course
//
//        let i1 = str.index(str.startIndex, offsetBy: str.characters.count - 3)
//        let i2 = str.index(after: i1)
//        let range = i1..<i2
//
//        str = str.substring(with: range)
//        
//        if let num = Int(str) {
//            return num
//        }
//        
//        return 0
//    }

    var creditHour: Int {

        if  var str = courseInfo?.course_id {
            let i1 = str.index(str.startIndex, offsetBy: str.characters.count - 3)
            let i2 = str.index(after: i1)
            let range = i1..<i2

            str = str.substring(with: range)
            return Int(str)!
        }

        return 0
    }

    init(uid_course: String) {
        _uid_course = uid_course
    }

    func updateGrade(type: CONSTANTS.keyOfGrades, newGrade: Int) {
        switch type {
        case .ASSIGNMENT:
            _assignment = newGrade
            break
        case .QUIZ_1:
            _quiz_1 = newGrade
            break
        case .QUIZ_2:
            _quiz_2 = newGrade
            break
        case .MIDTERM:
            _midterm = newGrade
            break
        case .FINAL:
            _final = newGrade
            break
        }
    }
    
    deinit {
        print("=============== > deinit Course_Grade")
    }
}
