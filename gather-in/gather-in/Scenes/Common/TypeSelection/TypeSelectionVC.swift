//
//  TypeSelectionVC.swift
//  gather-in
//
//  Created by Ramzy on 12/7/20.
//

import UIKit

class TypeSelectionVC: BaseView {

    // MARK:- IBOutlets
    @IBOutlet weak var teacherView: UIView!
    @IBOutlet weak var studentView: UIView!
    
    // MARK:- Properties

    
    // MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewsUI()
    }
        
    // MARK:- IBActions
    
    @IBAction func teacherPressed(_ sender: UIButton) {
        navigateToLoginAs(type: .teacher)
    }
    
    @IBAction func studentPressed(_ sender: UIButton) {
        navigateToLoginAs(type: .student)
    }
    
    func navigateToLoginAs(type: UserTypes) {
        let loginVC = LoginVC.instantiate(.login)
        loginVC.userType = type
        navigationRouter.push(view: loginVC)
    }
    
    // MARK:- Functions
    
    func setViewsUI() {
        teacherView.layer.cornerRadius = 10
        teacherView.layer.masksToBounds = true
        
        studentView.layer.cornerRadius = 10
        studentView.layer.masksToBounds = true
    }
    
}
