//
//  TeacherNotificationsVC.swift
//  gather-in
//
//  Created by Ramzy on 10/01/2021.
//

import UIKit

class TeacherNotificationsVC: BaseView {
    // MARK:- IBOutlets
    @IBOutlet weak var notificationsTableView: UITableView!
    
    // MARK:- Properties
    private var request: TeacherNotficationRequest?
    public var notificationsArray: [TeacherNotificationsDataResponse] = []
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewsUI() 
        setupTableView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        getNotifications()
    }
    
    // MARK:- Functions
    fileprivate func setViewsUI() {
        notificationsTableView.isSkeletonable = true
    }
    
    
    fileprivate func getNotifications() {
        guard let teacherId = cache.getString(key: .userId) else {return}
        guard let token = cache.getString(key: .token) else {return}
        notificationsTableView.showAnimatedSkeleton()
        request = TeacherNotficationRequest.getNotifications(teacherId: teacherId, accessToken: token)
        request?.send(TeacherNotificationsResponse.self, completion: {[weak self] (response) in
            self?.handleTeacherNotificationsResponse(response)
        })  
    }
    
    fileprivate func handleTeacherNotificationsResponse(_ response: ServerResponse<TeacherNotificationsResponse>) {
        switch response {
        case .success(let value):
            if value.status == true {
                guard let notifications = value.data else {return}
                self.notificationsArray = notifications
                DispatchQueue.main.async {
                    self.notificationsTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
            } else {
                self.notificationsTableView.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        case .failure(let error):
            print(error)
        }
    }

}
