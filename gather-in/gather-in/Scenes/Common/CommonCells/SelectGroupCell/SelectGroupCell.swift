//
//  SelectGroupCell.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit
import MOLH

protocol SelectGroupCellDelegate: class {
    func selectPressed(_ cell: SelectGroupCell)

}

class SelectGroupCell: UITableViewCell {
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    weak var delegate: SelectGroupCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            groupNameLabel.textAlignment = .left
        } else {
            groupNameLabel.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

 
    }
    
    @IBAction func selectPressed(_ sender: UIButton) {
        delegate?.selectPressed(self)
    }
}
