//
//  TeacherEditProfileVC.swift
//  gather-in
//
//  Created by Ramzy on 11/01/2021.
//

import UIKit
import MOLH
import Alamofire

class TeacherEditProfileVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var memberImageView: UIView!
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var request: TeacherEditProfileRequest?
    // Variables
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
    
    override func viewDidAppear(_ animated: Bool) {
//        setViewsData()
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
    
    @IBAction func saveButton(_ sender: Any) {
        if ValidateField(){
            requestUpdateProfileApi()
        }
    }
    
}


//MARK:- Helpers
extension TeacherEditProfileVC{
    
    // init view for the first time
    func initView(){
        
        NETWORK.deleget = self
        setViewsUI()
        setViewsData()
        requestGetInfoApi()
    }
    
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
        
        memberImageView.layer.cornerRadius = memberImageView.frame.width / 2
        memberImageView.clipsToBounds = true
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.ui.placeholderColor!])
        
    }
    
    fileprivate func setViewsData() {
        nameTextField.text = currentProfile?.fullName ?? ""
        emailTextField.text = currentProfile?.email ?? ""
        setImageView(forImageView: memberImage, andURL: (Config.BASEURL + (currentProfile?.picture ?? "")), andPlaceHolderImage: "dummyphoto1")
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
extension TeacherEditProfileVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == PROFILE_INFO {handelInfoResponse(response: data)}
         else if id == UPDATE_DATA{handelUpdateProfileResponse(response: data)}

    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }

    func requestGetInfoApi() {
//        showActivityIndicator()
        NETWORK.connectWithHeaderTo(api: ApiNames.PROFILE_INFO, andIdentifier: PROFILE_INFO, withLoader: true, forController: self, methodType: .get)
    }
        
    func handelInfoResponse(response: DataResponse<String>){
//        dismissActivityIndicator()
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
