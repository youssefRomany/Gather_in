//
//  TeacherChangePasswordVC.swift
//  gather-in
//
//  Created by Ramzy on 11/01/2021.
//

import UIKit
import MOLH

class TeacherChangePasswordVC: BaseView {
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    
    // MARK:- Properties
    var request: TeacherChangePasswordRequest?
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewsUI()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
   
    
    @IBAction func confirmButton(_ sender: Any) {
        guard let teacherId = cache.getString(key: .userId) else {return}
        guard let token = cache.getString(key: .token) else {return}
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty else {return}
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {return}
        guard let confirmNewPassword = confirmNewPasswordTextField.text, !confirmNewPassword.isEmpty else {return}
        guard newPassword == confirmNewPassword else {return}
        guard let email = cache.getString(key: .userEmail) else {return}
        self.showActivityIndicator()
        request = TeacherChangePasswordRequest.updatePassword(teacherId: teacherId, oldPassword: currentPassword, newPassword: newPassword, email: email, token: token)
        request?.send(BaseResponseModel.self, completion: {[weak self] (response) in
            self?.handleUpdateTecherPasswordResponse(response)
        })
    }


    // MARK:- Functions
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
    }

    
    fileprivate func handleUpdateTecherPasswordResponse(_ response: ServerResponse<BaseResponseModel>) {
        self.dismissActivityIndicator()
        switch response {
        case .success(let value):
            guard let message = value.message else {return}
            if value.status == true {
                displayAlert(title: "", subTitle: message, style: .success)
                navigationRouter.pop()
            } else {
                displayAlert(title: "", subTitle: message, style: .danger)
            }
        case .failure(let error):
            print(error)
        }
    }

}
