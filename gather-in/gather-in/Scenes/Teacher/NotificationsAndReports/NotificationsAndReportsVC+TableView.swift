//
//  NotificationsAndReportsVC+TableView.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit
import SkeletonView

extension NotificationsAndReportsVC: SkeletonTableViewDataSource, UITableViewDelegate {
    func setupTableView() {
        groupsTableView.dataSource = self
        groupsTableView.delegate = self
        groupsTableView.registerCellNib(cellClass: SelectGroupCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SelectGroupCell
        cell.groupNameLabel.text = groupsArray[indexPath.row].name
        if groupsArray[indexPath.row].isSelected == true {
            cell.selectButton.backgroundColor = UIColor.ui.color8
        }
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SelectGroupCell"
    }
    
}


extension NotificationsAndReportsVC: SelectGroupCellDelegate {
    func selectPressed(_ cell: SelectGroupCell) {
        let selectedIndexPath = self.groupsTableView.indexPath(for: cell)
        
        if groupsArray[selectedIndexPath!.row].isSelected == true {
            cell.selectButton.backgroundColor = UIColor.white
            groupsArray[selectedIndexPath!.row].isSelected = false
        } else {
            cell.selectButton.backgroundColor = UIColor.ui.color8
            groupsArray[selectedIndexPath!.row].isSelected = true
        }
    }
    
}
