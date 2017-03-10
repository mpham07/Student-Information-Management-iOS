//
//  ViewController.swift
//  cs_3420
//
//  Created by Minh Pham on 3/9/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    var courses = [Course]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference().child("courses")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        
            for snap in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    
                guard let item = snap.value as? [String: String] else {return }
                let uid = "1"
                   
                guard let course_id = item["course_id"], let name = item["name"], let type = item["type"] else { return }
                    let course = Course(uid: uid, course_id: course_id, name: name, type: type)
                    self.courses.append(course)
            }

        }, withCancel: nil)
    }
}

