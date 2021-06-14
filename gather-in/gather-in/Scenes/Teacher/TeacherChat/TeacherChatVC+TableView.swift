//
//  TeacherChatVC+TableView.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit

extension TeacherChatVC: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
       chatTableView.dataSource = self
       chatTableView.delegate = self
       chatTableView.registerCellNib(cellClass: ChatCell.self)
   }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let topview = UIView()
//        topview.heightAnchor.constraint(equalToConstant: 70).isActive = true
                
        let image = UIImageView(image: UIImage(named: "empty_messages"))
        image.contentMode = .scaleAspectFit
//        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        let label = UILabel()
        label.text = "There is no messages yet ....".localized
        label.textColor = UIColor.ui.color2
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let middleStackView = UIStackView(arrangedSubviews: [image,label])
        middleStackView.alignment = .center
        middleStackView.axis = .vertical
        middleStackView.distribution = .fill
        
        let bottomView = UIView()
        
        let stackView = UIStackView(arrangedSubviews: [topview,middleStackView,bottomView])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
//        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//

        return stackView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ChatCell
        
        if indexPath.row % 2 == 0 {
            cell.setChatBubbleType(type: .incoming)
        } else {
            cell.setChatBubbleType(type: .outgoing)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return messagesCount  > 0 ? 0 : tableView.frame.height
    }
}
