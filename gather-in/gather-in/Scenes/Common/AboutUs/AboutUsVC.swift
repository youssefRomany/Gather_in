//
//  AboutUsVC.swift
//  gather-in
//
//  Created by Ramzy on 12/13/20.
//

import UIKit
import MOLH
import Alamofire

class AboutUsVC: BaseView {
    
    //IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var aboutUsTextView: UITextView!
    
    // Constant
    let NETWORK = NetworkingHelper()
    let ABOUT_US = "ABOUT_US"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewsUI()
        NETWORK.deleget = self
        requestAboutUsApi()
    }
    

    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }

}



//MARK:- Networking
extension AboutUsVC: NetworkingHelperDeleget {
    func onHelper(getData data: DataResponse<String>, fromApiName name: String, withIdentifier id: String) {
        if id == ABOUT_US {handelAboutUsResponse(response: data)}
    }

    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        displayAlert(title: "", subTitle: localizedSitringFor(key: "unkwonError"), style: .danger)
    }
    
    func requestAboutUsApi() {
        NETWORK.connectWithHeaderTo(api: ApiNames.ABOUT_US+"?lang=\(L102Language.currentAppleLanguage())", andIdentifier: ABOUT_US, withLoader: false, forController: self, methodType: .get)
    }

    func handelAboutUsResponse(response: DataResponse<String>){
        print(response)
        switch response.response?.statusCode {
        case 200:
              do
                {
                let Resp = try JSONDecoder().decode([AboutRespons].self, from: response.data ?? Data())
                    aboutUsTextView.text = Resp.first?.body.html2String

              }catch let error{
                print(error,"joe")
                displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }

        default:
                do {
                  let resp = try JSONDecoder().decode(GlobalErrorRespons.self, from: response.data ?? Data())
                    displayAlert(title: "", subTitle: resp.data?.first?.msg ?? "", style: .danger)


                }catch let error{
                  print(error,"joe")
                  displayAlert(title: "", subTitle: localizedSitringFor(key: "unknownError"), style: .danger)
            }
        }
    }
}


struct AboutRespons: Codable {
    var id: Int?
    var body_ar: String?
    var body_en: String?
    
    var body: String{
        if L102Language.isRTL{
            return body_ar ?? ""
        }else{
            return body_en ?? ""
        }
    }
}
