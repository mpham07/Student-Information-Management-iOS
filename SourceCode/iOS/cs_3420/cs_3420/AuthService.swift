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

    func logOut(_ onComplete: Completion_And_Err?) {
        do {
            try FIRAuth.auth()?.signOut()
            onComplete?(nil)
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
                        
                        self.logOut(nil)
                        onComplete?(err, nil)
                        return
                    }

                    // Suceesfully got User info from DB
                    onComplete?(nil, userDB)
                }
            }
        })
    }

    func createNewStudentViewEmailPassword(email: String, password: String, info: [String: String], _ onComplete: Completion_Data_And_Err?) {

        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in

            if let err = error {
                onComplete?(err.localizedDescription, nil)
                return
            }

            // Successfully Created New Student

            if let user = user {
                DataService.instance.addNewUser(uid: user.uid, data: info, { (err) in

                    if let err = err {
                        onComplete?(err, nil)
                        return
                    }

                    // Successfully Added User Info To DB
                    onComplete?(nil, user.uid)
                })
            }
        })
    }

    func deleteAStudent(user: User, _ onComplete: Completion_And_Err?) {

        if let courses = user.course_grades {

            let numberOfCourses = courses.count

            var counter = 0

            for i in 0..<numberOfCourses {

                let courseGrade = courses[i]
                DataService.instance.getACourseInfo(uid: courseGrade.uid_course, { (error, info) in

                    if let err = error {
                        onComplete?(err)
                        return
                    }

                    courseGrade.courseInfo = info as? Course
                    counter += 1

                    if counter == numberOfCourses {
                        // There are full course infos
                        counter = 0

                        for i in 0..<numberOfCourses {
                            let courseGrade = courses[i]
                            if let courseInfo = courseGrade.courseInfo {

                                DataService.instance.deleteCoursesForStudent(user: user, course: courseInfo, { (error) in

                                    counter += 1
                                    
                                    if counter == numberOfCourses {
                                        
                                        StorageService.instance.deleteProfilePicture(user: user, { (err) in
                                            
                                            if let err = err {
                                                onComplete?(err)
                                            }else {
                                                DataService.instance.deleteUserInfo(user: user, { (err) in
                                                    onComplete?(err)
                                                })
                                            }
                                        })
                                        
                                    }
                                })
                            }
                        }
                    }
                })
            }

        } else {

            DataService.instance.deleteUserInfo(user: user, { (error) in
                onComplete?(error)
            })
        }
    }
}
