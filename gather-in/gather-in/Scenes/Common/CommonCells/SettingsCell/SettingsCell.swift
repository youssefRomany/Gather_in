//
//  SettingsCell.swift
//  gather-in
//
//  Created by Ramzy on 12/12/20.
//

import UIKit
import MOLH

class SettingsCell: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            itemLabel.textAlignment = .left
        } else {
            itemLabel.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
