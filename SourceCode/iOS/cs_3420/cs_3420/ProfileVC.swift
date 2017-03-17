//
//  ProfileVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/17/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SDWebImage

class ProfileVC: UIViewController {
    
    @IBOutlet weak var lblMajor: UILabel!
    @IBOutlet weak var lblCredits: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: CustomizedImageView!
    @IBOutlet weak var lblStudentID: UILabel!
    @IBOutlet weak var lblGPA: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI(user: AppState.instance.user!)
    }
    
    func updateUI(user: User) {
        
        if let image = user.photoUrl {
            imgProfile.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PROFILE_DEFAULT"), options: .refreshCached)
        }
        
        lblName.text = user.name
        
        guard let student_id = user.student_id else {
            return
        }
        
        lblStudentID.text = student_id
        lblGPA.text = user.GPA
        lblCredits.text = user.totalCredit
        lblMajor.text = user.major
    }
    
    @IBAction func btnOpenMenu_Pressed(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
}
