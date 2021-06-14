//
//  NotificationAndReportMessageVC.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit
import MOLH

class NotificationAndReportMessageVC: BaseView {
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    var selectedGroups: [String]?
    var request: NotificatioinsAndReportMessageRequest?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func backPressed(_ sender: Any) {
        navigationRouter.pop()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let token = cache.getString(key: .token) else {return}
        guard let message = messageTextView.text else {return}
        guard let selectedGroups = selectedGroups else {return}
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day, .year, .hour, .minute], from: Date())
        let year = String(components.year!)
        let month = String(components.month!)
        let day = String(components.day!)
        let hour = String(components.hour!)
        let minute = String(components.minute!)
        
        self.showActivityIndicator()
        request = NotificatioinsAndReportMessageRequest.sendQuestion(groups: selectedGroups, year: year, month: month, day: day, hour: hour, minute: minute, text: message, accessToken: token)
        request?.send(BaseResponseModel.self, completion: {[weak self] (response) in
            self?.handleSendQuestionResponse(response)
        })
    }
    
    // MARK:- Functions
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }
    
    fileprivate func handleSendQuestionResponse(_ response: ServerResponse<BaseResponseModel>) {
        self.dismissActivityIndicator()
        switch response {
        case .success(let value):
            if value.status == true {
                messageTextView.text = ""
                let sentSuccessfullyVC = SentSuccessfullyVC.instantiate(.sentSuccessfully)
                sentSuccessfullyVC.pageName =  "Notifications And Reports".localized
                navigationRouter.push(view: sentSuccessfullyVC)
            } else {
                guard let message = value.message else {return}
                self.displayAlert(title: "Something went wrong...".localized, subTitle: message, style: .danger)
            }
        case .failure(let error):
            print(error)
        }
    }
    
}
