//
//  ResultDetailsCell.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit
import MOLH

class ResultDetailsCell: UITableViewCell {
    @IBOutlet weak var leaderImage: UIImageView!{
        didSet{
            leaderImage.layer.cornerRadius = leaderImage.frame.size.height/2
            leaderImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var leaderName: UILabel!

    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var emptyMessagesImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if MOLHLanguage.currentAppleLanguage() == "en" {
            leaderName.textAlignment = .left
            messageTextView.textAlignment = .left
        } else {
            leaderName.textAlignment = .right
            messageTextView.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configreResultCell(answer: String) {
        if answer == "" {
            emptyMessagesImage.isHidden = false
            messageTextView.isHidden = true
        } else {
            emptyMessagesImage.isHidden = true
            messageTextView.isHidden = false
            messageTextView.text = answer
        }
    }
    
}
