//
//  AuthService.swift
//  cs_3420
//
//  Created by Minh Pham on 3/15/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthService {
    
    private static var _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func logOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    
    func logInviaEmailPassword(email: String, password: String, _ onComplete: Completion_Data_And_Err?) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
            
            if let err = err {
                
                onComplete?(err.localizedDescription, nil)
                return
            }
            
            // Successfully Sign In to FIR
            if let user = user {
                DataService.instance.getAUser(uid: user.uid) { (err, userDB) in
                    
                    if let err = err {
                        onComplete?(err, nil)
                        return
                    }
                    
                    // Suceesfully got User info from DB
                    onComplete?(nil, userDB)
                }
            }
        })
    }
}
