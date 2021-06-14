//
//  CommunicationDetailsVC+TableView.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit

extension CommunicationDetailsVC: UITableViewDataSource ,UITableViewDelegate {
     func setupTableView() {
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.registerCellNib(cellClass: CommunicationDetailsCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as CommunicationDetailsCell
        
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
}
