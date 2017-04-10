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

    static func showAlertView (title: String?, message: String, actionCompletion: Completion?, cancelCompletion: Completion?) {

        var alertTitle: String!
        if let title = title {
            alertTitle = title
        } else {
            alertTitle = CONSTANTS.notices.ALERT
        }

        let alert = AlertController(title: alertTitle, message: message, preferredStyle: .alert)

        alert.add(AlertAction(title: CONSTANTS.notices.CANCEL, style: .normal, handler: { (alertAction) in
            cancelCompletion?()
        }))

        alert.add(AlertAction(title: CONSTANTS.notices.YES, style: .destructive, handler: { alertAction in

            actionCompletion?()
        }))
        
        alert.present()
    }

    static func showAlertView(title: String?, message: String, cancelComplete: Completion?) {

        var alertTitle: String!
        if let title = title {
            alertTitle = title
        } else {
            alertTitle = CONSTANTS.notices.ALERT
        }

        let alert = AlertController(title: alertTitle, message: message, preferredStyle: .alert)

        alert.add(AlertAction(title: CONSTANTS.notices.OK, style: .destructive, handler: { (alertAction) in
            cancelComplete?()
        }))

        alert.present()
    }
}



