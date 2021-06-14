//
//  EditDepartmentVC.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 12/21/20.
//

import UIKit
import Alamofire

class EditDepartmentVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var departmentNameLabel: UILabel!
    @IBOutlet weak var departmentNameTextField: UITextField!
    @IBOutlet weak var departmentCodeTextField: UITextField!
    
    // Properties
    var selectedDepartmentId: String = ""
    var selectedDeparmentName: String = ""
    var selectedDepartmentCode: String = ""
    
    
    //MARK:- Constant
    let NETWORK = NetworkingHelper()
    let EDIT_DEPARTMENT = "EDIT_DEPARTMENT"

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }

    
    // MARK:- IBActions
    @IBAction func closePressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        if ValidateField(){
            requestEditApi()
        }

    }
 
}


//MARK:- helpers
extension EditDepartmentVC{
    
    func initView(){
        setViewsData()
        NETWORK.deleget = self
        departmentCodeTextField.isEnabled = true
        departmentCodeTextField.isUserInteractionEnabled = true
    }


    fileprivate func setViewsData() {
        departmentNameLabel.text = selectedDeparmentName
        departmentNameTextField.text = selectedDeparmentName
        departmentCodeTextField.text = selectedDepartmentCode
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
extension EditDepartmentVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == EDIT_DEPARTMENT {handelEditDepartmentResponse(response: data)}

    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    func requestEditApi() {
        self.showActivityIndicator()
        var paramters: [String: String] = [:]
        paramters["name"] = departmentNameTextField.text ?? ""
        paramters["code"] = departmentCodeTextField.text ?? ""
        paramters["id"] = selectedDepartmentId

        NETWORK.connectWithHeaderTo(api: ApiNames.UPDATE_DEPARTMENT, withParameters: paramters, andIdentifier: EDIT_DEPARTMENT, withLoader: true, forController: self, methodType: .post)
    }
        
    func handelEditDepartmentResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
                displayAlert(title: "", subTitle: localizedSitringFor(key: "editSuccessfully"), style: .success)
                navigationController?.popViewController(animated: true)

        default:
            do{
              let resp = try JSONDecoder().decode(GlobalErrorRespons.self, from: response.data ?? Data())
                displayAlert(title: "", subTitle: resp.message ?? "", style: .danger)

            }catch let error{
              print(error,"joe")
              displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
          }

        }
    }

}
