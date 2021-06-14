//
//  LeaderChatsVC+TableView.swift
//  gather-in
//
//  Created by Ramzy on 15/02/2021.
//

import UIKit


extension LeaderChatsVC: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        chatsTableView.dataSource = self
        chatsTableView.delegate = self
        chatsTableView.registerCellNib(cellClass: LeaderChatsCell.self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as LeaderChatsCell

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}
