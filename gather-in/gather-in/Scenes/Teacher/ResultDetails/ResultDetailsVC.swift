//
//  ResultDetailsVC.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit
import MOLH

class ResultDetailsVC: BaseView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var departmentAndGroupLabel: UILabel!
    @IBOutlet weak var answersTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        if MOLHLanguage.currentAppleLanguage() == "ar"{
                    backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
    }
    


}
