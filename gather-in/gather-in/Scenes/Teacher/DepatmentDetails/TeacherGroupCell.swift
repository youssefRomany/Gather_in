//
//  TeacherGroupCell.swift
//  gather-in
//
//  Created by Ramzy on 07/01/2021.
//

import UIKit
import MOLH

protocol TeacherGroupCellDelegate: class {
    func deletePressed(_ cell: TeacherGroupCell)
    func editPressed(_ cell: TeacherGroupCell)
}

class TeacherGroupCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!

    
    weak var delegate: TeacherGroupCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        if MOLHLanguage.currentAppleLanguage() == "en" {
            groupName.textAlignment = .left
        } else {
            groupName.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deletePressed(_ sender: UIButton) {
        delegate?.deletePressed(self)
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        delegate?.editPressed(self)
    }
}
