//
//  AlreadyRegisteredAlertVC.swift
//  gather-in
//
//  Created by Ramzy on 12/8/20.
//

import UIKit

class AlreadyRegisteredAlertVC: BaseView {
    // MARK:- IBOutlets
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK:- Properties
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewsUI()
    }
    
    // MARK:- IBActions
    @IBAction func cancelPressed(_ sender: UIButton) {
        navigationRouter.dismiss()
    }
    

    @IBAction func loginPressed(_ sender: UIButton) {
        let loginVC = LoginVC.instantiate(.login)
        navigationRouter.setAsRoot(view: loginVC)
      
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
    }
    
    // MARK:- Functions
    
    fileprivate func setViewsUI() {
        alertView.layer.cornerRadius = 10
        alertView.clipsToBounds = true
        
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
    }
}
