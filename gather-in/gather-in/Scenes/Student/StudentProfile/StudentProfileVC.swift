//
//  StudentProfileVC.swift
//  gather-in
//
//  Created by Ramzy on 12/12/20.
//

import UIKit
import MOLH
import Alamofire

class StudentProfileVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var memberImageView: UIView!
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // Properties
    var currentProfile: ProfileModel?
    var selectedImage: UIImage?

    // Constant
    let NETWORK = NetworkingHelper()
    let PROFILE_INFO = "PROFILE_INFO"
    let UPDATE_DATA = "UPDATE_DATA"

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    

    // MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    @IBAction func changeImagePressed(_ sender: UIButton) {
        AttachmentHandler.shared.showAttachmentImageActionSheet(vc: self)
                     
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            self.memberImage.image = image
            self.selectedImage = image

        }
    }
    
    @IBAction func changePasswordPressed(_ sender: UIButton) {
        let studentChangePasswordVC = StudentChangePasswordVC.instantiate(.studentChangePassword)
        navigationRouter.push(view:studentChangePasswordVC)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if ValidateField(){
            requestUpdateProfileApi()
        }
    }

}


//MARK:- Helpers
extension StudentProfileVC{
    
    // init view for the first time
    func initView(){
        
        setViewsUI()
        NETWORK.deleget = self
        requestGetInfoApi()
    }
    
    
    fileprivate func setViewsData() {
        
//        memberName.text = currentProfile?.fullName ?? ""
        nameTextField.text = currentProfile?.fullName ?? ""
        emailTextField.text = currentProfile?.email ?? ""
        setImageView(forImageView: memberImage, andURL: (Config.BASEURL + (currentProfile?.picture ?? "")), andPlaceHolderImage: "dummyphoto1")
    }
    
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
        
        memberImageView.layer.cornerRadius = memberImageView.frame.width / 2
        memberImageView.clipsToBounds = true
        
//        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
//
//        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
        
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
    }
    
    
     /// validate Fields
    ///
    /// - Returns: true or false
    func ValidateField() -> Bool{

        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
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

         return true
    }
}



//MARK:- Networking
extension StudentProfileVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == PROFILE_INFO {handelInfoResponse(response: data)}
         else if id == UPDATE_DATA{handelUpdateProfileResponse(response: data)}

    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    func requestGetInfoApi() {
        NETWORK.connectWithHeaderTo(api: ApiNames.PROFILE_INFO, andIdentifier: PROFILE_INFO, withLoader: true, forController: self, methodType: .get)
    }
        
    func handelInfoResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:
              do{
                let profileRespons = try JSONDecoder().decode(ProfileModel.self, from: response.data ?? Data())
                    currentProfile = profileRespons
                    setViewsData()
                
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
    
    
    func requestUpdateProfileApi() {

        var paramters: [String: String] = [:]

        paramters["email"] = emailTextField.text ?? ""
        paramters["fullName"] = nameTextField.text ?? ""
        var images: [UIImage] = []
        
        if let image = selectedImage{
            images.append(image)
        }
        
        NETWORK.connectToUploadObject(images: ["avatar" : images], withParameters: paramters, toApi: ApiNames.UPDATE_INFO, andIdentifier: UPDATE_DATA, fromController: self)
    }
    
    
    func handelUpdateProfileResponse(response: DataResponse<String>){
        switch response.response?.statusCode {
        case 200:

                self.displayAlert(title: "Success".localized, subTitle: "editSuccessfully".localized, style: .success)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.navigationController?.popViewController(animated: true)
                }

        default:
            displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
        }
    }


}
