//
//  ChangePasswordVC.swift
//  gather-in
//
//  Created by Ramzy on 18/02/2021.
//

import UIKit
import MOLH
import Alamofire

class ChangePasswordVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var oldPasswordStackView: UIStackView!
    

    // variables
    public var userEmail : String?
    var cameViaForgotPassword: Bool = false

    //Constant
    let NETWORK = NetworkingHelper()
    let CHANGE_PASSWORD = "CHANGE_PASSWORD"
    let UPDATE_DATA = "UPDATE_DATA"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    
    // MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {

        if validate(){
            if cameViaForgotPassword{
                requestChangePasswordApi()
            }else{
                requestUpdatePasswordApi()
            }
        }
        
    }

    
}


//MARK:- Helpers
extension ChangePasswordVC{
    
    func initView(){
        NETWORK.deleget = self
        setViewsUI()
        mainQueue {
            self.oldPasswordStackView.isHidden = self.cameViaForgotPassword
        }
    }
    
    // MARK:- Functions
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        continueButton.layer.cornerRadius = 5
        continueButton.clipsToBounds = true
    }
    
    // make validation
    func validate() -> Bool{
        
        if !cameViaForgotPassword{
            if oldPasswordTextField.text?.count ?? 0 < 6{
                displayAlert(title: "", subTitle: localizedSitringFor(key: "emptyOldPassword"), style: .danger)

                return false
            }
        }
        if newPasswordTextField.text?.count ?? 0 < 6{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "emptyNewPassword"), style: .danger)

            return false
        }
        
        if confirmNewPasswordTextField.text != newPasswordTextField.text {
            displayAlert(title: "", subTitle: localizedSitringFor(key: "equalPassword"), style: .danger)


            return false
        }
        
        return true
    }
}


//MARK:- Networking
extension ChangePasswordVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
        if id == CHANGE_PASSWORD {handelChangePasswordResponse(response: data)}
        else if id == UPDATE_DATA {handelUpdatePasswordResponse(response: data)}
    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    
    func requestChangePasswordApi() {

        var paramters: [String: String] = [:]
        if cameViaForgotPassword{
            paramters["email"] = userEmail
        }
        paramters["newPassword"] = newPasswordTextField.text ?? ""
        paramters["passwordConfirmation"] = confirmNewPasswordTextField.text ?? ""

        NETWORK.connectWithHeaderTo(api: ApiNames.CHANGE_PASSWORD, withParameters: paramters, andIdentifier: CHANGE_PASSWORD, withLoader: true, forController: self, methodType: .post)
    }
    
    func handelChangePasswordResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let resp = try JSONDecoder().decode(ValidateCodeRespons.self, from: response.data ?? Data())
                print(resp.code ?? "", "code")
//                guard let email = emailTextField.text , !email.isEmpty else {return}
//                let verficationVC = VerficationVC.instantiate(.verfication)
//                verficationVC.cameViaForgotPassword = true
//                verficationVC.userEmail = email
//                verficationVC.verficationCode = resp.code ?? ""
//                navigationRouter.push(view: verficationVC)

//                let verficationVC = VerficationVC.instantiate(.verfication)
//                verficationVC.userType = userType
//                verficationVC.verficationCode = resp.code ?? ""
//                navigationRouter.push(view: verficationVC)
                
                if cameViaForgotPassword{
                    self.displayAlert(title: "Success".localized, subTitle: "LoginAgain".localized, style: .success)
                    UserAccount.shared.logout()
                    UserAccount.shared.storeData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        let typeSelectionVC = TypeSelectionVC.instantiate(.typeSelection)
                        self.navigationRouter.setAsRoot(view: typeSelectionVC)
                    }

                }else{
                    
                }

              }catch let error{
                print(error,"joe")
                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }
//        case 409:
//            displayAlert(title: "", subTitle: localizedSitringFor(key: "ExistEmail"), style: .danger)
        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }
    
    func requestUpdatePasswordApi() {

        var paramters: [String: String] = [:]

        paramters["old_password"] = oldPasswordTextField.text ?? ""
        paramters["new_password"] = confirmNewPasswordTextField.text ?? ""

        NETWORK.connectWithHeaderTo(api: ApiNames.UPDATE_INFO, withParameters: paramters, andIdentifier: UPDATE_DATA, withLoader: true, forController: self, methodType: .post)
    }
    
    
    func handelUpdatePasswordResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
            if cameViaForgotPassword{

            }else{
                self.displayAlert(title: "Success".localized, subTitle: "SuccessfullyChangePassword".localized, style: .success)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.navigationController?.popViewController(animated: true)
                }

            }
//              do{
//                let resp = try JSONDecoder().decode(ValidateCodeRespons.self, from: response.data ?? Data())
//                print(resp.code ?? "", "code")
//
//
//                if cameViaForgotPassword{
//                    self.displayAlert(title: "Success".localized, subTitle: "SuccessfullyChangePassword".localized, style: .success)
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//
//                }else{
//
//                }
//
//              }catch let error{
//                print(error,"joe")
//                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
//            }
        case 401:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "WrongOldPassword"), style: .danger)
        default:
                do
                {
                  let resp = try JSONDecoder().decode(GlobalErrorRespons.self, from: response.data ?? Data())
                    displayAlert(title: "", subTitle: resp.data?.first?.msg ?? "", style: .danger)


                }catch let error{
                  print(error,"joe")
                  displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }
            
        }
    }

}
