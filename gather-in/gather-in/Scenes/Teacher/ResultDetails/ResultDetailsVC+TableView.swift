//
//  ResultDetailsVC+TableView.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit

extension ResultDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func setupTableView() {
       answersTableView.dataSource = self
        answersTableView.delegate = self
        answersTableView.estimatedRowHeight = 140.0
        answersTableView.rowHeight = UITableView.automaticDimension
        answersTableView.registerCellNib(cellClass: ResultDetailsCell.self)
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ResultDetailsCell
     
        cell.leaderName.text = "Mohamed Ahmed"
        
        let answer =  """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum .
"""
        cell.configreResultCell(answer: answer)
     
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
