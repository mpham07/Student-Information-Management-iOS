//
//  MenuVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/16/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import SDWebImage

class MenuVC: UIViewController {

    @IBOutlet weak var imgProfile: CustomizedImageView!
    @IBOutlet weak var lblNameUser: UILabel!
    @IBOutlet weak var lblStudentID: UILabel!
    @IBOutlet weak var lblGPA: UILabel!
    @IBOutlet weak var lblTakingCourses: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    var menuItems: [CONSTANTS.menuItems]!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileViewInfo(user: AppState.instance.user!)

    }

    func updateProfileViewInfo(user: User) {
        if let image = user.photoUrl {
            imgProfile.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PROFILE_DEFAULT"), options: .refreshCached)
        }
        lblNameUser.text = user.name

        guard let student_id = user.student_id else {
            return
        }

        lblStudentID.text = student_id
        lblGPA.text = user.GPA
        lblTakingCourses.text = user.takingCourses
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {

    func setUpTableView() {

        menuItems = [CONSTANTS.menuItems.profile,
            CONSTANTS.menuItems.courses,
            CONSTANTS.menuItems.settings,
            CONSTANTS.menuItems.logout]

        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuCell {

            cell.updateUI(itemInfo: menuItems[indexPath.row].rawValue)

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var destinationVC: UIViewController!
        switch menuItems[indexPath.row] {
        
        case CONSTANTS.menuItems.courses:
            destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseListNC")
            break
            
        case CONSTANTS.menuItems.profile:
            
            destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
        
            break
            
        case CONSTANTS.menuItems.settings:
            
            return
            
        case CONSTANTS.menuItems.logout:
            AuthService.instance.logOut({ (err) in
                self.slideMenuController()?.dismiss(animated: true, completion: nil)

            })
            
            return
        }

        self.slideMenuController()?.changeMainViewController(destinationVC, close: true)
    }
}
