//
//  SendQuestionVC+TableView.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit
import SkeletonView

extension SendQuestionVC: SkeletonTableViewDataSource, UITableViewDelegate {
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
        } else {
            cell.selectButton.backgroundColor = UIColor.white
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


extension SendQuestionVC: SelectGroupCellDelegate {
    func selectPressed(_ cell: SelectGroupCell) {
        let selectedIndexPath = self.groupsTableView.indexPath(for: cell)
        
        if selectedIndexPath?.row == 0 {
            if groupsArray[selectedIndexPath!.row].isSelected == true {
                for section in 0..<groupsTableView.numberOfSections {
                    for row in 0..<groupsTableView.numberOfRows(inSection: section) {
                        let indexPath = NSIndexPath(row: row, section: section)
                        let cell = groupsTableView.cellForRow(at: indexPath as IndexPath) as? SelectGroupCell
                        groupsArray[indexPath.row].isSelected = false
                        cell?.selectButton.backgroundColor = UIColor.white
                    }
                }
            } else {
                for section in 0..<groupsTableView.numberOfSections {
                    for row in 0..<groupsTableView.numberOfRows(inSection: section) {
                        let indexPath = NSIndexPath(row: row, section: section)
                        let cell = groupsTableView.cellForRow(at: indexPath as IndexPath) as? SelectGroupCell
                        groupsArray[indexPath.row].isSelected = true
                        cell?.selectButton.backgroundColor = UIColor.ui.color8
                    }
                }
            }
        } else {
            if groupsArray[selectedIndexPath!.row].isSelected == true {
                cell.selectButton.backgroundColor = UIColor.white
                groupsArray[selectedIndexPath!.row].isSelected = false
            } else {
                cell.selectButton.backgroundColor = UIColor.ui.color8
                groupsArray[selectedIndexPath!.row].isSelected = true
            }
        }
    }
}
