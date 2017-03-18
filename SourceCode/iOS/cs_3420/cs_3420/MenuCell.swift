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
            onNotify.isHidden = false
        }
        
        lblName.text = itemInfo
        imgIcon.image = UIImage(named: itemInfo)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        if selected {
            imgBackground.image = UIImage(named: "menuCell_Selected")
        }else {
            imgBackground.image = nil
        }
    }
    
    
}
