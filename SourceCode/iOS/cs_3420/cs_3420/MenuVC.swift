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
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {

    func setUpTableView() {

        if let user = AppState.instance.user, user.isStudent {
            menuItems = [CONSTANTS.menuItems.PROFILE,
            CONSTANTS.menuItems.COURSES,
            CONSTANTS.menuItems.NOTIFICATION,
            CONSTANTS.menuItems.LOGOUT]
            
        }else {
            menuItems = [CONSTANTS.menuItems.PROFILE,
                         CONSTANTS.menuItems.COURSES,
                         CONSTANTS.menuItems.STUDENTS,
                         CONSTANTS.menuItems.LOGOUT]
        }

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
        
        case CONSTANTS.menuItems.COURSES:
            destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseListNC")
            break
            
        case CONSTANTS.menuItems.PROFILE:
            
            destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
        
            break
            
        case CONSTANTS.menuItems.NOTIFICATION:
            
            tableView.cellForRow(at: indexPath)?.isSelected = false
            return
            
        case CONSTANTS.menuItems.LOGOUT:
            AuthService.instance.logOut({ (err) in
                self.slideMenuController()?.dismiss(animated: true, completion: nil)

            })

            return
        
        case CONSTANTS.menuItems.STUDENTS:
            destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudentListNC")
            break
        }

        self.slideMenuController()?.changeMainViewController(destinationVC, close: true)
    }
}
