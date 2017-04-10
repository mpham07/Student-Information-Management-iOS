//
//  GradeCell.swift
//  cs_3420
//
//  Created by Minh Pham on 3/17/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

class GradeCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblGrade: UITextField!

    func updateUI(course_grade: Course_Grade, name: CONSTANTS.nameOfGrades) {
        
        var grade = CONSTANTS.courses_grades.DEFAULT_GRADE

        switch name {
        case CONSTANTS.nameOfGrades.ASSIGNMENT:
            if let assignment = course_grade.assignment {
                grade = assignment
            }
            break
        case CONSTANTS.nameOfGrades.QUIZ_1:
            if let quiz_1 = course_grade.quiz_1 {
                grade = quiz_1
            }
            break

        case CONSTANTS.nameOfGrades.QUIZ_2:
            if let quiz_2 = course_grade.quiz_2 {
                grade = quiz_2
            }
            break

        case CONSTANTS.nameOfGrades.MIDTERM:
            if let midterm = course_grade.midterm {
                grade = midterm
            }
            break

        case CONSTANTS.nameOfGrades.FINAL:
            if let final = course_grade.final {
                grade = final
            }
            break
        }

        if (grade != CONSTANTS.courses_grades.DEFAULT_GRADE) {
            lblGrade.text = "\(grade)"
            if grade <= 60 {
                // Set font color to RED
                lblGrade.textColor = COLORS.RED
            }else {
                lblGrade.textColor = COLORS.DEFAULT
            }
            lblStatus.text = CONSTANTS.statusOfGrades.GRADED
        } else {
            lblGrade.text = nil
            lblStatus.text = CONSTANTS.statusOfGrades.IN_COMNG
        }
        
        lblName.text = name.rawValue
    }
    
    func enableEditingGrades(is editing: Bool) {
        
        if editing {
            lblGrade.isUserInteractionEnabled = true
            lblGrade.layer.borderWidth = 1.0
            lblGrade.placeholder = "0"
            
        }else {
            lblGrade.isUserInteractionEnabled = false
            lblGrade.layer.borderWidth = 0
            lblGrade.placeholder = ""
        }
    }
}
