//
//  SentSuccessfullyVC.swift
//  gather-in
//
//  Created by Ramzy on 12/11/20.
//

import UIKit

class SentSuccessfullyVC: BaseView {
    @IBOutlet weak var pageNameLabel: UILabel!
    
    var pageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageNameLabel.text = pageName
    }
    @IBAction func closePressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    



}
