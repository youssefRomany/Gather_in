//
//  ChatCell.swift
//  gather-in
//
//  Created by Ramzy on 12/10/20.
//

import UIKit

enum chatBubbleType {
    case incoming
    case outgoing
}

class ChatCell: UITableViewCell {
    @IBOutlet weak var memberImage: UIImageView!{
        didSet{
            memberImage.layer.cornerRadius = memberImage.frame.size.height/2
            memberImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var chatBubleView: UIView!
    @IBOutlet weak var chatBubbleStackView: UIStackView!
    @IBOutlet weak var chatBubbleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChatBubbleType(type:chatBubbleType){
        if (type == .incoming){
            chatBubbleStackView.alignment = .leading
            messageStackView.addArrangedSubview(messageStackView.subviews[1])
            chatBubbleImage.image = #imageLiteral(resourceName: "senderBubble")
            messageTextView.textColor = .black
        } else if (type == .outgoing) {
            chatBubbleStackView.alignment = .trailing
            messageStackView.addArrangedSubview(messageStackView.subviews[0])
            chatBubbleImage.image = #imageLiteral(resourceName: "receiver")
            messageTextView.textColor = .white
            
        }
    }
    
}
