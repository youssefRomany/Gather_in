//
//  CommunicationVC+TableView.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit

extension CommunicationVC : UITableViewDataSource, UITableViewDelegate {
    func setupTableView() {
        communicationTableView.dataSource = self
        communicationTableView.delegate = self
        communicationTableView.registerCellNib(cellClass: CommunicationCell.self)
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as CommunicationCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let communicationDetailsVC = CommunicationDetailsVC.instantiate(.communicationDetails)
        navigationRouter.push(view: communicationDetailsVC)
    }
}
