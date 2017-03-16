//
//  CourseCellTableViewCell.swift
//  cs_3420
//
//  Created by Minh Pham on 3/15/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {

    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtCourseID: UILabel!
    @IBOutlet weak var txtType: UILabel!
    @IBOutlet weak var txtAverage: UILabel!

    func updateUI(course: Course_Grade) {
        if let courseInfo = course.courseInfo {
            txtName.text = courseInfo.name
            txtType.text = courseInfo.type
            txtCourseID.text = courseInfo.course_id
            
            if let average = course.averge {
                txtAverage.text = "\(Int(average))"
            }
        }
    }
}
