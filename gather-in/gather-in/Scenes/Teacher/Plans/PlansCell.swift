//
//  PlansCell.swift
//  gather-in
//
//  Created by Ramzy on 07/01/2021.
//

import UIKit
import MOLH

class PlansCell: UITableViewCell {
    // MARK:- IBOutlets
    @IBOutlet weak var subscriptionImage: UIImageView!
    @IBOutlet weak var subscriptionType: UILabel!
    @IBOutlet weak var departmentsCountLabel: UILabel!
    @IBOutlet weak var groupCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    

    // MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
        if MOLHLanguage.currentAppleLanguage() == "en" {
            subscriptionType.textAlignment = .left
            departmentsCountLabel.textAlignment = .left
            groupCountLabel.textAlignment = .left
            priceLabel.textAlignment = .left
        } else {
            subscriptionType.textAlignment = .right
            departmentsCountLabel.textAlignment = .right
            groupCountLabel.textAlignment = .right
            priceLabel.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
