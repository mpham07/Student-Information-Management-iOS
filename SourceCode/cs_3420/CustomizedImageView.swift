//
//  CustomizedImageView.swift
//  cs_3420
//
//  Created by Minh Pham on 3/15/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedImageView: UIImageView {
    
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
    
    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
}
