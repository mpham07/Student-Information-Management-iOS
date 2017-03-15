//
//  CustomizedButton.swift
//  cs_3420
//
//  Created by Minh Pham on 3/14/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
}
