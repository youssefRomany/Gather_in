//
//  GroupResultsVC+TableView.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit
import SkeletonView

extension GroupResultsVC: SkeletonTableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.registerCellNib(cellClass: GroupResultsCell.self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as GroupResultsCell
        cell.groupName.text = resultsArray[indexPath.row].name
        cell.handleAnswerStatusAppearance(answers: resultsArray[indexPath.row].answers)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultDtailsVC = ResultDetailsVC.instantiate(.resultDetails)
        navigationRouter.push(view: resultDtailsVC)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "GroupResultsCell"
    }
    
}
