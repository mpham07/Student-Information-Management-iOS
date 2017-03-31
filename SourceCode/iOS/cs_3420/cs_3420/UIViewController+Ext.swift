//
//  UIViewController+Indicator.swift
//  cs_3420
//
//  Created by Minh Pham on 3/18/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation
import FTIndicator
import SloppySwiper

enum ProgressType: String{
    case LOADING = "Loading..."
    case UPDATING = "Updating..."
    case DELETING = "Deleting..."
}

extension UIViewController {
    
    func showProgress(type: ProgressType) {
      
        FTIndicator.showProgressWithmessage(type.rawValue, userInteractionEnable: false)
    }
    
    func showProgressLoading() {
        FTIndicator.showProgressWithmessage(CONSTANTS.indicatorMessage.LOADING, userInteractionEnable: false)
    }
    
    func showProgressUpdating() {
        FTIndicator.showProgressWithmessage(CONSTANTS.indicatorMessage.UPDATING, userInteractionEnable: false)
    }
    
    func showProgressDeleting() {
        FTIndicator.showProgressWithmessage(CONSTANTS.indicatorMessage.DELETING, userInteractionEnable: false)
    }
    
    func showError(err: String) {
        FTIndicator.showError(withMessage: err)
        self.dismissProgress()
    }
    
    func dismissProgress() {
        FTIndicator.dismissProgress()
    }
    
    
    func handleGoBackSwipeAction(swiper: inout SloppySwiper) {
        swiper = SloppySwiper.init(navigationController: self.navigationController)
        
        navigationController?.delegate = swiper;
    }
}
