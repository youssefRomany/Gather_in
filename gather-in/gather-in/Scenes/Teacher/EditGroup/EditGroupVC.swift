//
//  EditGroupVC.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit

class EditGroupVC: BaseView {
    // MARK:- IBOutlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var memberTextField: UITextField!
    @IBOutlet weak var membersTableView: UITableView!
    
    // MARK:- Properties
    var request: EditGroupRequest?
    var selectedDepartmentId: String?
    var selectedGroupId: String?
    var selectedGroupName: String?
    var deparmentMembersArray: [GetDepartmentMembersDataResponse] = []
    var groupMembersArray: [GetDepartmentMembersDataResponse] = []
    var finalArray: [GetDepartmentMembersDataResponse] = []
    
    
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
    @IBAction func closePressed(_ sender: UIButton) {
        navigationRouter.pop()
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        guard let groupId = selectedGroupId else {return}
        guard let groupName = groupNameTextField.text, !groupName.isEmpty else {return}
        let members = finalArray.filter({$0.isSelected == true}).map({$0.id})
        guard let token = cache.getString(key: .token) else {return}
        self.showActivityIndicator()
        request = EditGroupRequest.updateGroup(groupId: groupId, name: groupName, members: members, token: token)
        request?.send(BaseResponseModel.self, completion: {[weak self] (response) in
            self?.handleUpdateGroupResponse(response)
        })
        
    }
    
    // MARK:- Functions
    fileprivate func setViewsUI() {
        membersTableView.isSkeletonable = true
        
    }
    
    fileprivate func setViewsData() {
        guard let groupName = selectedGroupName else {return}
        groupNameTextField.text = groupName
        getDepartmentMembers()
    }
    
    fileprivate func getDepartmentMembers() {
        guard let departmentId = selectedDepartmentId else {return}
        guard let token = cache.getString(key: .token) else {return}
        
        membersTableView.showAnimatedSkeleton()
        request = EditGroupRequest.getDepartmentMembers(departmentId: departmentId, token: token)
        request?.send(GetDepartmentMembersResponse.self, completion: {[weak self] (response) in
            self?.handleGetDepartmentMembersResponse(response)
        })
    }
    
    fileprivate func handleGetDepartmentMembersResponse(_ response: ServerResponse<GetDepartmentMembersResponse>) {
        switch response {
        case .success(let value):
            if value.status == true {
                guard let members = value.data else {return}
                
                self.deparmentMembersArray = members
                getGroupMembers()
            } else {
                
            }
        case .failure(let error):
            print(error)
        }
    }
    
    
    fileprivate func getGroupMembers() {
        guard let groupId = selectedGroupId else {return}
        guard let token = cache.getString(key: .token) else {return}
        request = EditGroupRequest.getGroupMembers(groupId: groupId, token: token)
        request?.send(GetDepartmentMembersResponse.self, completion: {[weak self] (response) in
            self?.handleGetGroupMembersResponse(response)
        })
    }
    
    
    
    fileprivate func handleGetGroupMembersResponse(_ response: ServerResponse<GetDepartmentMembersResponse>) {
        self.dismissActivityIndicator()
        switch response {
        case .success(let value):
            if value.status == true {
                guard let members = value.data else {return}
                self.groupMembersArray = members
                finalArray.removeAll()
                for member in deparmentMembersArray {
                    if groupMembersArray.contains(where: {$0.id == member.id}) {
                        finalArray.append(GetDepartmentMembersDataResponse(id: member.id, username: member.username, isSelected: true))
                    } else {
                        finalArray.append(GetDepartmentMembersDataResponse(id: member.id, username: member.username, isSelected: false))
                    }
                }
                DispatchQueue.main.async {
                    self.membersTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
            } else {
                self.membersTableView.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        case .failure(let error):
            print(error)
        }
    }
    
    
    
    fileprivate func handleUpdateGroupResponse(_ response: ServerResponse<BaseResponseModel>) {
        self.dismissActivityIndicator()
        switch response {
        case .success(let value):
            guard let message = value.message else {return}
            if value.status == true {
                self.displayAlert(title: "", subTitle: message, style: .success)
                navigationRouter.pop()
            } else {
                self.displayAlert(title: "", subTitle: message, style: .danger)
            }
        case .failure(let error):
            print(error)
        }
    }

    
}

