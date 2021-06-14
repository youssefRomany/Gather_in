//
//  TeacherNotificationsVC+TableView.swift
//  gather-in
//
//  Created by Ramzy on 10/01/2021.
//

import UIKit
import SkeletonView

extension TeacherNotificationsVC: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.registerCellNib(cellClass: BasicNotificationCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as BasicNotificationCell
        cell.notifcationTitle.text = notificationsArray[indexPath.row].text
        
        let dateString = "\(notificationsArray[indexPath.row].year)-\(notificationsArray[indexPath.row].month)-\(notificationsArray[indexPath.row].day)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: Date? = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        cell.notificationDate.text = dateFormatter.string(from: date!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let topview = UIView()
////        topview.heightAnchor.constraint(equalToConstant: 70).isActive = true
//
//        let image = UIImageView(image: UIImage(named: "empty_notification"))
//        image.contentMode = .scaleAspectFit
////        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
//
//        let label = UILabel()
//        label.text = "There is no notifications yet ..."
//        label.textColor = UIColor.ui.color2
//        label.textAlignment = .center
//        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        let middleStackView = UIStackView(arrangedSubviews: [image,label])
//        middleStackView.alignment = .center
//        middleStackView.axis = .vertical
//        middleStackView.distribution = .fill
//
//        let bottomView = UIView()
//
//        let stackView = UIStackView(arrangedSubviews: [topview,middleStackView,bottomView])
//        stackView.alignment = .center
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
////        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
////
//
//        return stackView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return notificationsArray.count  > 0 ? 0 : tableView.frame.height
//    }
//
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "BasicNotificationCell"
    }
}
