//
//  LeaderChatsCell.swift
//  gather-in
//
//  Created by Ramzy on 15/02/2021.
//

import UIKit
import MOLH

class LeaderChatsCell: UITableViewCell {
    @IBOutlet weak var communicationNameLabel: UILabel!
    @IBOutlet weak var moderatorNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            communicationNameLabel.textAlignment = .left
            moderatorNameLabel.textAlignment = .left
        } else {
            communicationNameLabel.textAlignment = .right
            moderatorNameLabel.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
