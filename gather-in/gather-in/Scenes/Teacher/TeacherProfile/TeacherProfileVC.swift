//
//  TeacherProfileVC.swift
//  gather-in
//
//  Created by Ramzy on 10/01/2021.
//

import UIKit
import Alamofire

class TeacherProfileVC: BaseView {
    
    // MARK:- IBOutlets
    @IBOutlet weak var teacherImageView: UIView!
    @IBOutlet weak var teacherImage: UIImageView!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    // Variables
    var currentProfile: ProfileModel?
    var selectedImage: UIImage?

    // Constant
    let NETWORK = NetworkingHelper()
    let PROFILE_INFO = "PROFILE_INFO"

    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad() 

        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    // MARK:- IBActions
    @IBAction func settingsPressed(_ sender: UIButton) {
        let teacherSettings = TeacherSettingsVC.instantiate(.teacherSettings)
        navigationRouter.push(view: teacherSettings)
    }
    
}



//MARK:- Helpers
extension TeacherProfileVC{
    
    // init view for the first time
    func initView(){
        
        NETWORK.deleget = self
        setViewsUI()
        setViewsData()
        requestGetInfoApi()
    }
    
    fileprivate func setViewsData() {
        teacherName.text = currentProfile?.fullName ?? ""
        emailLabel.text = currentProfile?.email ?? ""
        setImageView(forImageView: teacherImage, andURL: (Config.BASEURL + (currentProfile?.picture ?? "")), andPlaceHolderImage: "dummyphoto1")
    }
    
    fileprivate func setViewsUI() {
        teacherImageView.clipsToBounds = false
        teacherImageView.layer.borderWidth = 1
        teacherImageView.layer.borderColor = UIColor.ui.color3?.cgColor
        teacherImageView.layer.cornerRadius = teacherImage.frame.width / 2
        teacherImageView.clipsToBounds = true
        teacherImage.layer.cornerRadius = teacherImage.frame.width / 2
        teacherImage.clipsToBounds = true
    }

}


//MARK:- Networking
extension TeacherProfileVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
         if id == PROFILE_INFO {handelInfoResponse(response: data)}

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
    
}
