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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isUserInteractionEnabled = false
    }
    
    @IBInspectable var textOrange: Bool = false {
    
        didSet {
            if textOrange {
                self.textColor = COLORS.ORANGE
            }else {
                self.textColor = COLORS.DEFAULT
            }
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    var isEditingMode: Bool = false {
        didSet{
            if isEditingMode == true {
                isUserInteractionEnabled = true
                borderWidth = 1
                borderColor = COLORS.DEFAULT
                cornerRadius = 4
            }else {
                borderWidth = 0
                cornerRadius = 0
                isUserInteractionEnabled = false
            }
        }
    }

}
