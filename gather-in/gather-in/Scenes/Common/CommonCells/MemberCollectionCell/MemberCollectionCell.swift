//
//  MemberCollectionCell.swift
//  gather-in
//
//  Created by Ramzy on 12/10/20.
//

import UIKit

class MemberCollectionCell: UICollectionViewCell {
    @IBOutlet weak var memberImageView: UIView!{
        didSet{
            memberImageView.layer.cornerRadius = memberImageView.frame.width / 2
            memberImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var memberImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
