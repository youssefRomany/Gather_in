//
//  SelectLeaderCell.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit
import MOLH

protocol SelectLeaderCellDelegate: class {
    func selectPressed(_ cell: SelectLeaderCell)
}


class SelectLeaderCell: UITableViewCell {
    @IBOutlet weak var memberImageView: UIView!{
        didSet{
            memberImageView.layer.cornerRadius = memberImageView.frame.width / 2
            memberImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    weak var delegate: SelectLeaderCellDelegate?
    
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
    
    func handleSelectButtonApperance(state: Bool?) {
        if state == true {
            selectButton.backgroundColor = UIColor.ui.color8
            selectButton.setTitle("selected".localized, for: .normal)
            selectButton.setTitleColor(UIColor.white, for: .normal)

        } else {
            selectButton.backgroundColor = UIColor.ui.color9
            selectButton.setTitle("select".localized, for: .normal)
            selectButton.setTitleColor(UIColor.white, for: .normal)

        }
    }
    
    @IBAction func selectPressed(_ sender: UIButton) {
        delegate?.selectPressed(self)
    }
    
}
