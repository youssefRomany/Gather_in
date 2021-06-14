//
//  EditGroupVC+TableView.swift
//  gather-in
//
//  Created by Ramzy on 12/02/2021.
//

import UIKit
import SkeletonView

extension EditGroupVC: SkeletonTableViewDataSource,UITableViewDelegate {
    
    func setupTableView() {
        membersTableView.dataSource = self
        membersTableView.delegate = self
        membersTableView.registerCellNib(cellClass: SelectMemberCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SelectMemberCell
        cell.memberNameLabel.text = finalArray[indexPath.row].username
        if finalArray[indexPath.row].isSelected == true {
            cell.selectButton.backgroundColor = UIColor.ui.color8
        } else {
            cell.selectButton.backgroundColor = UIColor.white
        }
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SelectMemberCell"
    }
    
}


extension EditGroupVC: SelectMemberCellDelegate {
    func selectPressed(_ cell: SelectMemberCell) {
        let selectedIndexPath = self.membersTableView.indexPath(for: cell)
        if finalArray[selectedIndexPath!.row].isSelected == true {
            cell.selectButton.backgroundColor = UIColor.white
            finalArray[selectedIndexPath!.row].isSelected = false
        } else {
            cell.selectButton.backgroundColor = UIColor.ui.color8
            finalArray[selectedIndexPath!.row].isSelected = true
        }
    }
    
    
}
