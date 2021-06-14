//
//  BasicNotificationCell.swift
//  gather-in
//
//  Created by Ramzy on 12/11/20.
//

import UIKit
import MOLH

class BasicNotificationCell: UITableViewCell {
    @IBOutlet weak var notifcationTitle: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if MOLHLanguage.currentAppleLanguage() == "en" {
            notifcationTitle.textAlignment = .left
            notificationDate.textAlignment = .left
        } else {
            notifcationTitle.textAlignment = .right
            notificationDate.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
