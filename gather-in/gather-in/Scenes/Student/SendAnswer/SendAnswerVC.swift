//
//  SendAnswer.swift
//  gather-in
//
//  Created by Ramzy on 12/11/20.
//

import UIKit

class SendAnswerVC: BaseView {
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var starIcon: UIImageView!
    @IBOutlet weak var memberImageView: UIView! {
        didSet {
            memberImageView.layer.cornerRadius = memberImageView.frame.width / 2
            memberImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var leaderLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func sendAnswerPressed(_ sender: UIButton) {
        let sentSuccessfullyVC = SentSuccessfullyVC.instantiate(.sentSuccessfully)
        sentSuccessfullyVC.pageName = "Send Answer".localized
        navigationRouter.push(view: sentSuccessfullyVC)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
}
