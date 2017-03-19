//
//  CustomizedTextField.swift
//  cs_3420
//
//  Created by Minh Pham on 3/18/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedTextField: UITextField {

    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }

}
