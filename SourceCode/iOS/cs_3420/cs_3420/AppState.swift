//
//  AppState.swift
//  cs_3420
//
//  Created by Minh Pham on 3/9/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation

class AppState {
    
    private static var _instance = AppState()
    private var _user: User?
    
    static var instance: AppState {
        return _instance
    }
    
    var user: User? {
        get {
            return _user
        }
        set {
            _user = newValue
        }
    }
}
