//
//  EditGroupRequest.swift
//  gather-in
//
//  Created by Ramzy on 12/02/2021.
//

import Foundation
import Alamofire

enum EditGroupRequest: URLRequestBuilder {
    case getDepartmentMembers(departmentId:String, token:String)
    case getGroupMembers(groupId: String, token: String)
    case updateGroup(groupId: String, name:String, members:[String],token:String)
    
    var path: String {
        switch self {
        
        case .getDepartmentMembers:
            return "get-department-members"
            
        case .getGroupMembers:
            return "get-group-members"
            
        case .updateGroup:
            return "update-group"
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getDepartmentMembers(let departmentId,let token):
            param["department_id"] = departmentId
            param["access_token"] = token
            
        case .getGroupMembers(let groupId,let token):
            param["group_id"] = groupId
            param["access_token"] = token
            
        case .updateGroup(let groupId,let name,let members,let token):
            param["group_id"] = groupId
            param["name"] = name
            param["members"] = members
            param["access_token"] = token
        }
        return param
    }
    
    var method: HTTPMethod {
        switch self {
        
        case .getDepartmentMembers:
            return .post
            
        case .getGroupMembers:
            return .post
            
        case .updateGroup:
            return .post
        }
    }
}
