//
//  TeacherDepartmentCell.swift
//  gather-in
//
//  Created by Ramzy on 07/01/2021.
//

import UIKit
import MOLH

protocol TeacherDepartmentCellDelegate: class {
    func deletePressed(_ cell: TeacherDepartmentCell)
    func editPressed(_ cell: TeacherDepartmentCell)
}

class TeacherDepartmentCell: UITableViewCell {
    @IBOutlet weak var departmentName: UILabel!
    @IBOutlet weak var numberOfGroups: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!

    weak var delegate: TeacherDepartmentCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        if MOLHLanguage.currentAppleLanguage() == "en" {
            departmentName.textAlignment = .left
            numberOfGroups.textAlignment = .left
        } else {
            departmentName.textAlignment = .right
            numberOfGroups.textAlignment = .right
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
