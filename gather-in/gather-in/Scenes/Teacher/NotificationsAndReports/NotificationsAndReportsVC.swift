//
//  NotificationsAndReportsVC.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit
import SkeletonView
import MOLH

class NotificationsAndReportsVC: BaseView {
    // MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var groupsTableView: UITableView!
    
    // MARK:- Properties
    var request: NotificationsAndReportsRequest?
    var groupsArray: [TeacherGroupsDataResponse] = []
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setViewsUI() 
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        setViewsData()
    }
    
    // MARK:- IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        let selectedGroups = groupsArray.filter({$0.isSelected == true}).map({$0.id})
        let notificaitonAndReportsMessageVC = NotificationAndReportMessageVC.instantiate(.notificationAndReportMessage)
        notificaitonAndReportsMessageVC.selectedGroups = selectedGroups
        navigationRouter.push(view: notificaitonAndReportsMessageVC)
        
    }
    
    // MARK:- Functions
    fileprivate func setViewsUI() {
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        groupsTableView.isSkeletonable = true
    }
    
    fileprivate func setViewsData() {
        getTeacherGroups()
    }
    
    fileprivate func getTeacherGroups() {
        guard let teacherId = cache.getString(key: .userId) else {return}
        guard let token = cache.getString(key: .token) else {return}
        groupsTableView.showAnimatedSkeleton()
        request = NotificationsAndReportsRequest.getTeacherGroups(teacherId: teacherId, accessToken: token)
        request?.send(TeacherGroupsResponse.self, completion: {[weak self] (response) in
            self?.handleGetTeacherGroupsResponse(response)
        })
    }
    
    fileprivate func handleGetTeacherGroupsResponse(_ response: ServerResponse<TeacherGroupsResponse>) {
        self.dismissActivityIndicator()
        switch response {
        case .success(let value):
            if value.status == true {
                guard let groups = value.data else {return}
                groupsArray = groups
                DispatchQueue.main.async {
                    self.groupsTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
            } else {
                self.groupsTableView.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        case .failure(let error):
            print(error)
        }
    }
    
    
}
