//
//  TeacherChatVC.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit
import MOLH

class TeacherChatVC: BaseView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var groupAndCountLabel: UILabel!
    @IBOutlet weak var membersCollectionView: UICollectionView!
    @IBOutlet weak var chatTableView: UITableView!
    
    var messagesCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupTableView()
        
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }    }
    
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
}
