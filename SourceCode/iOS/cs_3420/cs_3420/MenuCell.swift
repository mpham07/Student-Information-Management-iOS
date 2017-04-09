//
//  MenuCell.swift
//  cs_3420
//
//  Created by Minh Pham on 3/16/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var onNotify: UISwitch!
    @IBOutlet weak var imgBackground: UIImageView!

    func updateUI(itemInfo: String) {

        if itemInfo == CONSTANTS.menuItems.LOGOUT.rawValue {
            lineView.isHidden = false
        }

        if itemInfo == CONSTANTS.menuItems.NOTIFICATION.rawValue {
            
            if let _ = AppState.instance.user!.pushToken {
                onNotify.setOn(true, animated: false)
            }
            
            onNotify.isHidden = false
        }

        lblName.text = itemInfo
        imgIcon.image = UIImage(named: itemInfo)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        if selected {
            imgBackground.image = UIImage(named: "menuCell_Selected")
        } else {
            imgBackground.image = nil
        }
    }

    @IBAction func switchNotif(_ sender: Any) {

        if let switchNotification = sender as? UISwitch {
            let user = AppState.instance.user!
            if switchNotification.isOn {
                if let tokenString = AuthService.instance.pushToken {
                    
                    DataService.instance.storePushToken(student: user, tokenString: tokenString, { (error) in
                        
                        if let _ = error {
                            switchNotification.setOn(false, animated: true)
                            return
                        }
                    })
                }else {
                    switchNotification.setOn(false, animated: true)
                }
            }else {
                
                DataService.instance.deletePushToken(user: user, { (error) in
                    if let _ = error {
                        switchNotification.setOn(true, animated: true)
                        return
                    }
                })
            }
        }
    }
}
