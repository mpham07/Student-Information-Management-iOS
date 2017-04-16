//
//  cs_3420Tests.swift
//  cs_3420Tests
//
//  Created by Minh Pham on 4/9/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import XCTest
@testable import cs_3420

class cs_3420Tests: XCTestCase {
    
    let courseGrade = Course_Grade(uid_course: "CS_3420")
    let student = User(uid: "uid", email: "email", name: "name", role: "role")
    
    func testAvarage() {
        
        var average = courseGrade.averge
        XCTAssertNil(average)
        
        courseGrade.assignment = 85
        courseGrade.quiz_1 = 80
        courseGrade.final = 75
        average = courseGrade.averge
        XCTAssertEqual(average, 80)
        
        courseGrade.assignment = 90
        courseGrade.quiz_1 = 30
        courseGrade.final = 50
        courseGrade.midterm = 10
        average = courseGrade.averge
        XCTAssertEqual(average, 45)
    }
    
    func testGPAOfAStudent() {
        let gpa = student.GPA
        XCTAssertEqual(gpa, "N/A")
        
        let CS_3420 = Course_Grade(uid_course: "CS_3420")
        CS_3420.assignment = 85
        CS_3420.quiz_1 = 80
        CS_3420.final = 75
        XCTAssertEqual(CS_3420.valueOfGradeLetter?.rawValue, 3.0)
        
        let CS_2402 = Course_Grade(uid_course: "CS_2402")
        CS_2402.assignment = 90
        CS_2402.quiz_1 = 30
        CS_2402.final = 50
        CS_2402.midterm = 100
        
        student.course_grades = [Course_Grade]()
        student.course_grades?.append(CS_3420)
        student.course_grades?.append(CS_2402)
        XCTAssertEqual(CS_2402.valueOfGradeLetter?.rawValue, 1.0)
        
        XCTAssertEqual(student.GPA, "2.0")
    }
    
    func testStudentNumberOfCourseTaking() {
        
        student.course_grades = [Course_Grade]()
        
        let CS_3420 = Course_Grade(uid_course: "CS_3420")
        student.course_grades?.append(CS_3420)
        XCTAssertEqual(student.takingCourses, "1")
        let CS_2402 = Course_Grade(uid_course: "CS_2402")
        student.course_grades?.append(CS_2402)
        XCTAssertEqual(student.takingCourses, "2")
    }
    
    func testStudentTotalCredit() {
        student.course_grades = [Course_Grade]()
        
        let courseInfo = Course(uid: "CS_3420", course_id: "CS 3420", name: "name", type: "type", registed: 1)
        let CS_3420 = Course_Grade(uid_course: "CS_3420")
        CS_3420.courseInfo = courseInfo
        student.course_grades?.append(CS_3420)
        XCTAssertEqual(student.totalCredit, "4")
        
        let CS_2402 = Course_Grade(uid_course: "CS_2402")
        courseInfo.course_id = "CS 2402"
        CS_2402.courseInfo = courseInfo
        student.course_grades?.append(CS_2402)
        XCTAssertEqual(student.totalCredit, "8")
        
        let CS_3402 = Course_Grade(uid_course: "CS_3402")
        courseInfo.course_id = "CS 3402"
        CS_3402.courseInfo = courseInfo
        student.course_grades?.append(CS_2402)
        XCTAssertEqual(student.totalCredit, "12")
    }
}
