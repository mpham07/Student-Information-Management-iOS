//
//  Libs.swift
//  cs_3420
//
//  Created by Minh Pham on 3/19/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation
import SDCAlertView

class Libs {
   
    private static var _instance = Libs()
    static var instance: Libs {
        return _instance
    }
    
    static func showAlertView (title: String, message: String, _ onComplete: @escaping ()->()) {
        
        let alert = AlertController(title: title, message: message, preferredStyle: .alert)
        alert.add(AlertAction(title: "Cancel", style: .normal))
        alert.add(AlertAction(title: "Yes", style: .destructive, handler: { alertAction in
            
            onComplete()
        }))
        
        alert.present()
    }
    
    static func colorWithHexString(_ hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        
        let hexint = Int(intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    static func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: hexStr)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

//extension UIColor {
//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }
//    
//    convenience init(netHex:Int) {
//        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
//    }
    

//}

