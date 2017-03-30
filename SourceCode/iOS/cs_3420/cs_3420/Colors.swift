//
//  Colors.swift
//  cs_3420
//
//  Created by Minh Pham on 3/29/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit

struct COLORS {

    static let DEFAULT = colorWithHexString("2C4158")
    static let ORANGE = colorWithHexString("AB6426")
    static let RED = UIColor.red
}

extension COLORS {
    // Function helpers
    
    internal static func colorWithHexString(_ hexString: String, alpha: CGFloat? = 1.0) -> UIColor {
        
        let hexint = Int(intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    private static func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: hexStr)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
