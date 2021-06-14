//
//  CommunicationVC.swift
//  gather-in
//
//  Created by Ramzy on 09/01/2021.
//

import UIKit

class CommunicationVC: BaseView {
    @IBOutlet weak var communicationTableView: UITableView!
    var request: ChatIDTeacherAndLeaderResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getTeacherChatId()
    }
    
    fileprivate func getTeacherChatId() {
        guard let token = cache.getString(key: .token) else {return}
        guard let teacherId = cache.getString(key: .userId) else {return}
        print("the teacher Id is :",teacherId)
        
        request = ChatIDTeacherAndLeaderResponse.getChatID(groupId: "grp-12", teacherId: teacherId, leaderId: "s", typeChat: "tl")
        request?.send(ChatIDModel.self, completion: {[weak self] (response) in
            self?.handleGetTeacherDepartmentsResponse(response)
        })
    }
    
    fileprivate func handleGetTeacherDepartmentsResponse(_ response: ServerResponse<ChatIDModel>) {
        switch response {
        case .success(let value):
            
                print("the id is :",value._id)
            
        case .failure(let error):
            print(error)
        }
    }

    
}
