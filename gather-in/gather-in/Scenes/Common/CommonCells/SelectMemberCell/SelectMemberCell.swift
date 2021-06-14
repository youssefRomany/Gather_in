//
//  SelectMemberCell.swift
//  gather-in
//
//  Created by Ramzy on 12/02/2021.
//

import UIKit
import MOLH

protocol SelectMemberCellDelegate: class {
    func selectPressed(_ cell: SelectMemberCell)

}

class SelectMemberCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var memberImageContainerView: UIView!{
        didSet{
            memberImageContainerView.layer.cornerRadius = memberImageContainerView.frame.width / 2
            memberImageContainerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    weak var delegate: SelectMemberCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if MOLHLanguage.currentAppleLanguage() == "en" {
            memberNameLabel.textAlignment = .left
        } else {
            memberNameLabel.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func selectPressed(_ sender: UIButton) {
        delegate?.selectPressed(self)
    }
    
}
