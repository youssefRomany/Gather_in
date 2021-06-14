//
//  ForgotPasswordVC.swift
//  gather-in
//
//  Created by Ramzy on 14/02/2021.
//

import UIKit
import MOLH
import Alamofire

class ForgotPasswordVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK:- Constant
    let NETWORK = NetworkingHelper()
    let SEND_FORGET_CODE = "SEND_FORGET_CODE"

    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    // MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        if ValidateField(){
            requestForgetPasswordApi()
        }
    }
        
}


//MARK:- Helpers
extension ForgotPasswordVC{
    
    func initView() {
        
        setViewsUI()
        NETWORK.deleget = self
    }
    
    // set view design
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
        
        continueButton.layer.cornerRadius = 5
        continueButton.clipsToBounds = true
    }

    
     /// validate Fields
    ///
    /// - Returns: true or false
    func ValidateField() -> Bool{

        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "EmptyMAil"), style: .danger)

                return false
        }
        
        if !isValidEmail(emailTextField.text ?? ""){
            displayAlert(title: "", subTitle: localizedSitringFor(key: "UnValidEmail"), style: .danger)
            return false
        }

         return true
    }
}


//MARK:- Networking
extension ForgotPasswordVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == SEND_FORGET_CODE {handelForgetPasswordResponse(response: data)}
    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    
    func requestForgetPasswordApi() {

        var paramters: [String: String] = [:]
        paramters["email"] = emailTextField.text ?? ""

        NETWORK.connectWithHeaderTo(api: ApiNames.FORGET_PASSWORD, withParameters: paramters, andIdentifier: SEND_FORGET_CODE, withLoader: true, forController: self, methodType: .post)
    }
    
    func handelForgetPasswordResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let resp = try JSONDecoder().decode(ValidateCodeRespons.self, from: response.data ?? Data())
                print(resp.code ?? "", "code")
                guard let email = emailTextField.text , !email.isEmpty else {return}
                let verficationVC = VerficationVC.instantiate(.verfication)
                verficationVC.cameViaForgotPassword = true
                verficationVC.userEmail = email
                verficationVC.verficationCode = resp.code ?? ""
                navigationRouter.push(view: verficationVC)

//                let verficationVC = VerficationVC.instantiate(.verfication)
//                verficationVC.userType = userType
//                verficationVC.verficationCode = resp.code ?? ""
//                navigationRouter.push(view: verficationVC)

              }catch let error{
                print(error,"joe")
                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }
        case 409:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "NotExistEmail"), style: .danger)
        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }

}
