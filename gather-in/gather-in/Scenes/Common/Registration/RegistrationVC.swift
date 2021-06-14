//
//  RegistrationVC.swift
//  gather-in
//
//  Created by Ramzy on 12/7/20.
//

import UIKit
import MOLH
import Alamofire

class RegistrationVC: BaseView {
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailIconImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordIconImage: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameIconImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK:- Properties
    public var userType: UserTypes? = .teacher
    
    //MARK:- Constant
    let NETWORK = NetworkingHelper()
    let SEND_EMAIL_CODE = "SEND_EMAIL_CODE"

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
            requestSendCodeApi()
        }
    }

}


//MARK:- Helpers
extension RegistrationVC{
    
    func initView() {
        
        setViewsUI()
        NETWORK.deleget = self

    }
    
    // set view design
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Name".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
        
        
        continueButton.layer.cornerRadius = 5
        continueButton.clipsToBounds = true
    }
    
    fileprivate func resetFieldsImage() {
        emailIconImage.image = UIImage(named: "phone_normal")
        passwordIconImage.image = UIImage(named: "passowrd_normal")
        userNameIconImage.image =  UIImage(named: "passowrd_normal")
    }
    
     /// validate Fields
    ///
    /// - Returns: true or false
    func ValidateField() -> Bool{

        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "emptyname"), style: .danger)


              return false
          }
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "EmptyMAil"), style: .danger)

                return false
        }
        if !isValidEmail(emailTextField.text ?? ""){
            displayAlert(title: "", subTitle: localizedSitringFor(key: "UnValidEmail"), style: .danger)
            return false
        }
        
        if passwordTextField.text?.count ?? 0 < 6{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "UnValidPassword"), style: .danger)

            return false
        }


         return true
    }
}


//MARK:- Networking
extension RegistrationVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == SEND_EMAIL_CODE {handelSendEmailResponse(response: data)}
    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    
    func requestSendCodeApi() {

        var paramters: [String: String] = [:]
        paramters["email"] = emailTextField.text ?? ""

        NETWORK.connectWithHeaderTo(api: ApiNames.SEND_EMAIL, withParameters: paramters, andIdentifier: SEND_EMAIL_CODE, withLoader: true, forController: self, methodType: .post)

    }
    
    
    func handelSendEmailResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let resp = try JSONDecoder().decode(ValidateCodeRespons.self, from: response.data ?? Data())
                print(resp.code ?? "", "code")
                var paramters: [String: String] = [:]
                
                paramters["fullName"] = usernameTextField.text ?? ""
                paramters["email"] = emailTextField.text ?? ""
                paramters["password"] = passwordTextField.text ?? ""
                paramters["passwordConfirmation"] = passwordTextField.text ?? ""
                switch userType {
                case .student:
                    paramters["kind"] = "student"
                case .teacher:
                    paramters["kind"] = "teacher"
                case .none:
                    break
                }
                let verficationVC = VerficationVC.instantiate(.verfication)
                verficationVC.userType = userType
                verficationVC.verficationCode = resp.code ?? ""
                verficationVC.paramters = paramters
                navigationRouter.push(view: verficationVC)

              }catch let error{
                print(error,"joe")
                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }
        case 409:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "ExistEmail"), style: .danger)

//              do{
//                let register = try JSONDecoder().decode(RegisterResponse.self, from: response.data ?? Data())
//
//
//              }catch let error{
//                print(error,"joe")
//                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
//            }
        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }

}
