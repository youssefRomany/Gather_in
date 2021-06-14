//
//  CommunicationCell.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit
import MOLH

class CommunicationCell: UITableViewCell {
    @IBOutlet weak var memberImageView: UIView!{
        didSet{
            memberImageView.layer.cornerRadius = memberImageView.frame.width / 2
            memberImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var departmentAndGroupLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            memberNameLabel.textAlignment = .left
            departmentAndGroupLabel.textAlignment = .left
            messageLabel.textAlignment = .left
        } else {
            memberNameLabel.textAlignment = .right
            departmentAndGroupLabel.textAlignment = .right
            messageLabel.textAlignment = .left
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
