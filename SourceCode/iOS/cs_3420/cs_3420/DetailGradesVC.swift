//
//  DetailGradesVC.swift
//  cs_3420
//
//  Created by Minh Pham on 3/17/17.
//  Copyright © 2017 devmen. All rights reserved.
//

import UIKit
import SloppySwiper

class DetailGradesVC: UIViewController {

    var swiper = SloppySwiper()
    
    @IBOutlet weak var lblNameCourse: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var nameGrades: [CONSTANTS.nameOfGrades]!
    var courseGrade: Course_Grade?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        setUpHeaderAndFooter()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        handleGoBackSwipeAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.slideMenuController()?.removeLeftGestures()
    }
    
    @IBAction func btnBack_Pressed(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setUpHeaderAndFooter() {
        if let courseGrade = courseGrade {
            lblAverage.text = "\(courseGrade.averge!)"
            lblNameCourse.text = courseGrade.courseInfo!.course_id
        }
    }
    
    func handleGoBackSwipeAction() {
        self.swiper = SloppySwiper.init(navigationController: self.navigationController)
        
        navigationController?.delegate = self.swiper;
    }
}

extension DetailGradesVC: UITableViewDelegate, UITableViewDataSource {

    func setUpTableView() {
        
        nameGrades = [CONSTANTS.nameOfGrades.ASSIGNMENT,
            CONSTANTS.nameOfGrades.QUIZ_1,
            CONSTANTS.nameOfGrades.QUIZ_2,
            CONSTANTS.nameOfGrades.MIDTERM,
            CONSTANTS.nameOfGrades.FINAL]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 70.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "GradeCell", for: indexPath) as? GradeCell {

            if let courseGrade = courseGrade {
                let nameGrade = nameGrades[indexPath.row]
                cell.updateUI(course_grade: courseGrade, name: nameGrade)
            }

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return nameGrades.count
    }
}
