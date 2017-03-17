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
    
    func updateUI(itemInfo: String) {
        
        if itemInfo == CONSTANTS.menuItems.logout.rawValue {
            lineView.isHidden = false
        }
        
        lblName.text = itemInfo
        imgIcon.image = UIImage(named: itemInfo)
    }
}
