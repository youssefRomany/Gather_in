//
//  ExtentionForListOfSubcriptions.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 12/21/20.
//


import UIKit
import SkeletonView

extension PlansVC: UITableViewDelegate,SkeletonTableViewDataSource{
    // MARK:- Setup
    func setupTableView() {
        plansTableView.dataSource = self
        plansTableView.delegate = self
        plansTableView.registerCellNib(cellClass: PlansCell.self)
    }
    
    // MARK:- Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plansArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as PlansCell
        cell.subscriptionType.text = plansArray[indexPath.row].name
        cell.departmentsCountLabel.text = "Create up to ".localized  + " \(plansArray[indexPath.row].maxDepartments)" + "deapartments".localized
        cell.groupCountLabel.text = "Create up to ".localized + " \(plansArray[indexPath.row].maxGroups)" + "groups".localized
        
        cell.priceLabel.text = plansArray[indexPath.row].cost + " " + plansArray[indexPath.row].currency
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.planID = plansArray[indexPath.row].planId ?? ""
    }
    
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PlansCell"
    }
    
}

