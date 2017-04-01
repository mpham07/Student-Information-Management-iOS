//
//  StorageService.swift
//  cs_3420
//
//  Created by Minh Pham on 3/31/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import Foundation
import FirebaseStorage

class StorageService {
    private static var _instance = StorageService()

    static var instance: StorageService {
        return _instance
    }
    
    var main_ref: FIRStorageReference {
        return FIRStorage.storage().reference()
    }

    var images_ref: FIRStorageReference {
        return main_ref.child(CONSTANTS.storage.STORAGE_PROFILE_IMAGES)
    }
    
    func uploadAProfilePictureToStorage(user: User, fileName: String, uploadData: Data, _ onComplete: Completion_And_Err?) {
        let _ = images_ref.child(fileName)
        //ref.put(uploadData, metadata: nil) { (metadate, err) in
            
        //}
    }
    
    func deleteProfilePicture(user: User,  _ onComplete: Completion_And_Err?) {
        images_ref.child(user.photoImagePath).delete { (err) in
            if let err = err {
                onComplete?(err.localizedDescription)
            }else {
                onComplete?(nil)
            }
        }
    }
    
    func getDownloadUrl(path: String) {
      //  main_ref.child(path)
    }
}
