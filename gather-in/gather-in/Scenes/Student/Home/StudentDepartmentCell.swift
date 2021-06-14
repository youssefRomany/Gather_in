//
//  StudentDepartmentCell.swift
//  gather-in
//
//  Created by Ramzy on 12/8/20.
//

import UIKit
import MOLH

class StudentDepartmentCell: UITableViewCell {
    @IBOutlet weak var departmentName: UILabel!
    @IBOutlet weak var leaderName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if MOLHLanguage.currentAppleLanguage() == "en" {
            departmentName.textAlignment = .left
            leaderName.textAlignment = .left
        } else {
            departmentName.textAlignment = .right
            leaderName.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
