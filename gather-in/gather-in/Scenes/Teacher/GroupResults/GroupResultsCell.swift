//
//  GroupResultsCell.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit

class GroupResultsCell: UITableViewCell {
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var answerStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func handleAnswerStatusAppearance(answers: Int) {
        if answers > 0 {
            answerStatus.text = "Answer exist".localized
            answerStatus.textColor = UIColor.ui.color8
        } else {
            answerStatus.text = "No answer found".localized
            answerStatus.textColor = UIColor.red
        }
    }
}
