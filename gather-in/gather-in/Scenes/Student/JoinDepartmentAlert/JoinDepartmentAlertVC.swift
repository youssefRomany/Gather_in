//
//  JoinDepartmentAlert.swift
//  gather-in
//
//  Created by Ramzy on 12/9/20.
//

import UIKit
import Alamofire

class JoinDepartmentAlertVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var departmentCodeTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    // Constant
    let NETWORK = NetworkingHelper()
    let JOIN_DEPARTMENT = "JOIN_DEPARTMENT"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    
    // MARK:- IBActions
    @IBAction func cancelButton(_ sender: UIButton) {
        navigationRouter.dismiss()
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {

        if ValidateField(){
            requestJoindepartmentApi()
        }
    }

}


//MARK:- helpers
extension JoinDepartmentAlertVC{
    
    func initView(){
        
        setViewsUI()
        NETWORK.deleget = self
    }
    
    
    // set view design
    fileprivate func setViewsUI() {
        departmentCodeTextField.attributedPlaceholder = NSAttributedString(string: "Enter verfication code".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
        
        confirmButton.layer.cornerRadius = 10
        confirmButton.clipsToBounds = true
    }
    
    
     /// validate Fields
    ///
    /// - Returns: true or false
    func ValidateField() -> Bool{

        if departmentCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "EmptyCode"), style: .danger)

                return false
        }

         return true
    }
}


//MARK:- Networking
extension JoinDepartmentAlertVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == JOIN_DEPARTMENT {handelJoinDepartmentResponse(response: data)}
    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    
    func requestJoindepartmentApi() {

        var paramters: [String: String] = [:]
        paramters["code"] = departmentCodeTextField.text ?? ""

        NETWORK.connectWithHeaderTo(api: ApiNames.JOIN_DEPARTMENT, withParameters: paramters, andIdentifier: JOIN_DEPARTMENT, withLoader: true, forController: self, methodType: .post)
    }
    
    func handelJoinDepartmentResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let resp = try JSONDecoder().decode(ValidateCodeRespons.self, from: response.data ?? Data())
                displayAlert(title: "", subTitle: localizedSitringFor(key: "EnterDepartment"), style: .success)
                navigationRouter.dismiss()


              }catch let error{
                print(error,"joe")
                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }

        default:
            do{
              let resp = try JSONDecoder().decode(GlobalErrorRespons.self, from: response.data ?? Data())
                displayAlert(title: "", subTitle: resp.data?.first?.msg ?? "", style: .danger)


            }catch let error{
              print(error,"joe")
              displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
          }
        }
    }

}
