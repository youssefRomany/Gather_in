//
//  CreateDepartmentVC.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 12/21/20.
//

import UIKit
import Alamofire

class CreateDepartmentVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var departmentNameTextField: UITextField!
    @IBOutlet weak var departmentCodeTextField: UITextField!
    
    // MARK:- Properties
    private var request: CreateDepartmentRequest?
    
    //MARK:- Constant
    let NETWORK = NetworkingHelper()
    let CREAT = "CREAT"

    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NETWORK.deleget = self
    }
    
    
    // MARK:- IBActions
    @IBAction func closePressed(_ sender: UIButton) {
        navigationRouter.pop()
        
    }
    
    @IBAction func donePressed(_ sender: UIButton) {

        if ValidateField(){
            requestCreateApi()
        }
        
    }
    
}


//MARK:- helpers
extension CreateDepartmentVC{
    
    
    fileprivate func resetFields() {
        departmentNameTextField.text = ""
        departmentCodeTextField.text = ""
    }

    
     /// validate Fields
    ///
    /// - Returns: true or false
    func ValidateField() -> Bool{

        if departmentNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "EmptyDepartmenName"), style: .danger)

                return false
        }
        
        if departmentCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            displayAlert(title: "", subTitle: localizedSitringFor(key: "EmptyDepartmentCode"), style: .danger)

                return false
        }
         return true
    }
}


//MARK:- Networking
extension CreateDepartmentVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == CREAT {handelCreatDepartmentResponse(response: data)}

    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    func requestCreateApi() {
        self.showActivityIndicator()
        var paramters: [String: String] = [:]
        paramters["name"] = departmentNameTextField.text ?? ""
        paramters["code"] = departmentCodeTextField.text ?? ""

        NETWORK.connectWithHeaderTo(api: ApiNames.CREAT_DEPARTMENT, withParameters: paramters, andIdentifier: CREAT, withLoader: true, forController: self, methodType: .post)
    }
        
    func handelCreatDepartmentResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
                displayAlert(title: "", subTitle: localizedSitringFor(key: "DepartmentAdded"), style: .success)
                navigationController?.popViewController(animated: true)

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
