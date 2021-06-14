//
//  LoginVC.swift
//  gather-in
//
//  Created by Ramzy on 12/7/20.
//

import UIKit
import Alamofire

class LoginVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var emailIconImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordIconImage: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK:- variables
    public var userType: UserTypes?

    //MARK:- Constant
    let NETWORK = NetworkingHelper()
    let LOGIN = "LOGIN"

    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    // MARK:- IBActions
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        let forgotPasswordVC = ForgotPasswordVC.instantiate(.forgotPassword)
        navigationRouter.push(view: forgotPasswordVC)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if ValidateField(){
            resetFieldsImage()
            requestLoginApi()
        }
    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
        let registrationVC = RegistrationVC.instantiate(.registration)
        registrationVC.userType = userType
        navigationRouter.push(view: registrationVC)
        
    }
    
}


//MARK:- Helpers
extension LoginVC{
    
    // init view
    func initView() {
        
        setViewsUI()
        NETWORK.deleget = self
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
        
        if passwordTextField.text?.count ?? 0 < 6{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "UnValidPassword"), style: .danger)

            return false
        }

         return true
    }
    
    // setup View setting
    fileprivate func setViewsUI() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
    }
    
    // set up icons
    fileprivate func resetFieldsImage() {
        emailIconImage.image = UIImage(named: "phone_normal")
        passwordIconImage.image = UIImage(named: "passowrd_normal")
    }
}

//MARK:- Networking
extension LoginVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == LOGIN {handelLoginResponse(response: data)}

    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    func requestLoginApi() {

        var paramters: [String: String] = [:]
        paramters["email"] = emailTextField.text ?? ""
        paramters["password"] = passwordTextField.text ?? ""

        NETWORK.connectWithHeaderTo(api: ApiNames.SIGN_IN, withParameters: paramters, andIdentifier: LOGIN, withLoader: true, forController: self, methodType: .post)

    }
        
    func handelLoginResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let register = try JSONDecoder().decode(RegisterResponse.self, from: response.data ?? Data())
                UserAccount.shared.Token = register.token ?? ""
                UserAccount.shared.id = register.userId ?? 0
                UserAccount.shared.isLoggedIn = true

                if register.kind ?? "" == "student"{
                    userType = .student
                }else{
                    userType = .teacher
                }
                
                switch userType {
                case .teacher:
                    UserAccount.shared.isStudent = false
                case .student:
                    UserAccount.shared.isStudent = true
                default:
                    break
                }
                UserAccount.shared.storeData()
                
                switch userType {
                case .teacher:
                    let mainTabbarVC = UIStoryboard(name: "MainTabBar", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
                    navigationController?.pushViewController(mainTabbarVC, animated: true)

                case .student:
                    let studentHomeVC = StudentHomeVC.instantiate(.studentHome)
                    navigationRouter.setAsRoot(view: studentHomeVC)
                    
                default:
                    break
                }

              }catch let error{
                print(error,"joe")
                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }
        case 401:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "NoEmailFound"), style: .danger)
        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }

}
