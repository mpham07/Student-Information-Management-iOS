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
    case UPLOADING = "Uploading..."
    case ADDING = "Adding..."
}

extension UIViewController {
    
    func showProgress(type: ProgressType, userInteractionEnable: Bool) {
      
        FTIndicator.showProgressWithmessage(type.rawValue, userInteractionEnable: userInteractionEnable)
    }
    
    func dismissProgress() {
      
        FTIndicator.dismissProgress()
    }
    
    func handleGoBackSwipeAction(swiper: inout SloppySwiper) {
        swiper = SloppySwiper.init(navigationController: self.navigationController)
        
        navigationController?.delegate = swiper;
    }
}
