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
   
//    private static var _instance = Libs()
//    static var instance: Libs {
//        return _instance
//    }
    
    static func showAlertView (title: String, message: String, actionTitle: String?, _ onComplete: Completion?) {
        
        let alert = AlertController(title: title, message: message, preferredStyle: .alert)
        
        var cancelTitle = "OK"
        
        if actionTitle != nil {
            cancelTitle = "Cancel"
            
            alert.add(AlertAction(title: cancelTitle, style: .normal))
            alert.add(AlertAction(title: actionTitle!, style: .destructive, handler: { alertAction in
                
                onComplete?()
            }))
            alert.present()
            return
        }
        
        alert.add(AlertAction(title: cancelTitle, style: .destructive))
        alert.present()
    }
}


    
