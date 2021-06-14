//
//  DepartmentGroupsCell.swift
//  gather-in
//
//  Created by Ramzy on 06/02/2021.
//

import UIKit
import MOLH

class DepartmentGroupsCell: UITableViewCell {
    
    // IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            groupNameLabel.textAlignment = .left
        } else {
            groupNameLabel.textAlignment = .right
        }

        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
