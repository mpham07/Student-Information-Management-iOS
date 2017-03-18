//
//  StudentCell.swift
//  cs_3420
//
//  Created by Minh Pham on 3/18/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {
    @IBOutlet weak var imgProfile: CustomizedImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTaking: UILabel!
    @IBOutlet weak var lblGPA: UILabel!
    

    func updateUI(student: User) {
        if let img = student.photoUrl {
            imgProfile.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: CONSTANTS.imagesAssets.PROFILE_DEFAULT))
        }
        
        lblName.text = student.name
        lblTaking.text = student.takingCourses
        lblGPA.text = student.GPA
    }
}
