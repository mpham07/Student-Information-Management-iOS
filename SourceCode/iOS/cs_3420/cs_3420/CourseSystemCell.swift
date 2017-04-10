//
//  CourseSystemCell.swift
//  cs_3420
//
//  Created by Minh Pham on 3/18/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

class CourseSystemCell: UITableViewCell {

    @IBOutlet weak var txtCourseID: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtType: UILabel!
    @IBOutlet weak var txtEnrolled: UILabel!

    func updateUI(course: Course) {

        txtCourseID.text = course.course_id
        txtName.text = course.name
        txtType.text = course.type
        txtEnrolled.text = "\(course.enrolled)"
    }
}

