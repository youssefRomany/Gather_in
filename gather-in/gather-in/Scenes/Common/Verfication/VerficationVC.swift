//
//  VerficationVC.swift
//  gather-in
//
//  Created by Ramzy on 12/8/20.
//

import UIKit
import MOLH
import Alamofire

class VerficationVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var verficationCodeTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK:- Variables
    public var userType: UserTypes?
    public var userEmail : String?
    private var timerSeconds = 120
    private var countDownTimer: Timer?
    var verficationCode: String = ""
    public var cameViaForgotPassword: Bool = false
    var paramters: [String: String] = [:]
    
    
    //MARK:- Constant
    let NETWORK = NetworkingHelper()
    let REGISTER = "REGISTER"
    let SEND_EMAIL_CODE = "SEND_EMAIL_CODE"
    let SEND_FORGET_CODE = "SEND_FORGET_CODE"

    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    deinit {
        countDownTimer?.invalidate()
    }
    
    // MARK:- IBActions
    @IBAction func continuePressed(_ sender: UIButton) {
        
        makeRegister()
    }
 
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- Helpers
extension VerficationVC{
    
    func initView() {
        startCountDown()
        NETWORK.deleget = self
    }
    
    // when pressed on continue button to complete register or complete change password
    func makeRegister(){
        guard let enteredVerficationCode = verficationCodeTextField.text else {return}
        
        
        if enteredVerficationCode == verficationCode {
            if cameViaForgotPassword == true {
                let changePasswordVC = ChangePasswordVC.instantiate(.changePassword)
                changePasswordVC.userEmail = userEmail //self.paramters["email"] ?? ""
                changePasswordVC.cameViaForgotPassword = true
                navigationRouter.push(view:changePasswordVC)
            } else {
                requestRegisterApi()
            }
        } else {
            iconImage.image = UIImage(named: "ic_error_copy")
        }
    }
    
    // set up views
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        continueButton.layer.cornerRadius = 5
        continueButton.clipsToBounds = true
    }

    // set up timer
    fileprivate func startCountDown() {
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.timerSeconds -= 1
            if self?.timerSeconds == 0 {
                
                // Handle To Send Code Again
                self?.timerSeconds = 120
                if ((self?.cameViaForgotPassword) == true){
                    print("mmmmmmmmmmm call forget")
                    self?.requestForgetPasswordApi()
                }else{
                    print("mmmmmmmmmmm send code again")
                    self?.requestSendCodeApi()
                }
                self?.startCountDown()
                timer.invalidate()
            } else if let seconds = self?.timerSeconds {
                print("ssssxsxsxasxasx ")
                self?.timerLabel.text = "\((seconds % 3600) / 60):\((seconds % 3600) % 60)"
            }
        }
    }
}


//MARK:- Networking
extension VerficationVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == REGISTER {handelRegisterResponse(response: data)}
         else if id == SEND_EMAIL_CODE {handelSendEmailResponse(response: data)}
         else if id == SEND_FORGET_CODE {handelForgetPasswordResponse(response: data)}

    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    func requestRegisterApi() {

        NETWORK.connectWithHeaderTo(api: ApiNames.SIGN_UP, withParameters: paramters, andIdentifier: REGISTER, withLoader: true, forController: self, methodType: .post)

    }
        
    func handelRegisterResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let register = try JSONDecoder().decode(RegisterResponse.self, from: response.data ?? Data())
                UserAccount.shared.Token = register.token ?? ""
                UserAccount.shared.id = register.userId ?? 0
                UserAccount.shared.isLoggedIn = true

                switch userType {
                case .teacher:
                    UserAccount.shared.isStudent = false
                case .student:
                    UserAccount.shared.isStudent = true
                default:
                    break
                }
                UserAccount.shared.storeData()

                iconImage.image = UIImage(named: "ic_done")
                switch userType {
                case .teacher:
                    let teacherHomeVC = TeacherHomeVC.instantiate(.teacherHome)
                    navigationRouter.setAsRoot(view: teacherHomeVC)
                    
//                    pushToView(withId: "TeacherHomeVC", withStoryBoard: OurStoryboards.teacherHome)
                    countDownTimer?.invalidate()

                    
                case .student:
                    let studentHomeVC = StudentHomeVC.instantiate(.studentHome)
                    navigationRouter.setAsRoot(view: studentHomeVC)
                    countDownTimer?.invalidate()

                    
                default:
                    break
                }

              }catch let error{
                print(error,"joe")
                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }
        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }
    
    
    func requestSendCodeApi() {

        var paramter: [String: String] = [:]
        paramter["email"] = self.paramters["email"] ?? ""

        NETWORK.connectWithHeaderTo(api: ApiNames.SEND_EMAIL, withParameters: paramter, andIdentifier: SEND_EMAIL_CODE, withLoader: true, forController: self, methodType: .post)

    }
    
    
    func handelSendEmailResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let resp = try JSONDecoder().decode(ValidateCodeRespons.self, from: response.data ?? Data())
                print(resp.code ?? "", "code")
                verficationCode = resp.code ?? ""


              }catch let error{
                print(error,"joe")
                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }
        case 409:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "ExistEmail"), style: .danger)

        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }
    
    func requestForgetPasswordApi() {

        var paramters: [String: String] = [:]
        paramters["email"] = userEmail

        NETWORK.connectWithHeaderTo(api: ApiNames.FORGET_PASSWORD, withParameters: paramters, andIdentifier: SEND_FORGET_CODE, withLoader: true, forController: self, methodType: .post)
    }
    
    func handelForgetPasswordResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let resp = try JSONDecoder().decode(ValidateCodeRespons.self, from: response.data ?? Data())
                verficationCode = resp.code ?? ""
     

//                let verficationVC = VerficationVC.instantiate(.verfication)
//                verficationVC.userType = userType
//                verficationVC.verficationCode = resp.code ?? ""
//                navigationRouter.push(view: verficationVC)

              }catch let error{
                print(error,"joe")
                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }
        case 409:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "ExistEmail"), style: .danger)
        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }

}
