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

    func uploadAProfilePictureToStorage(user: User, fileName: String, uploadData: Data, _ onComplete: Completion_Data_And_Err?) {
        
        images_ref.child(fileName).put(uploadData, metadata: nil) { (metadata, err) in

            if let err = err {
                onComplete?(err.localizedDescription, nil)
                return
            }

            guard let path = metadata?.downloadURL()?.absoluteString else {
                onComplete?("Cannot get PhotoUrl", nil)
                return }
            
            let userInfo = [CONSTANTS.users.PHOTO_URL: path]

            // Successfully
            DataService.instance.updateAUserInfo(user: user, data: userInfo, { (err) in

                if let err = err {
                     onComplete?(err, nil)
                    return
                }

                // success
                onComplete?(nil, path)
            })
        }
    }

    func deleteProfilePicture(user: User, _ onComplete: Completion_And_Err?) {
        images_ref.child(user.photoImagePath).delete { (err) in
            if let err = err {
                onComplete?(err.localizedDescription)
            } else {
                onComplete?(nil)
            }
        }
    }

    func getDownloadUrl(path: String) {
        //  main_ref.child(path)
    }
}
