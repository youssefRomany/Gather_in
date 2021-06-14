//
//  CreateGroupRequest.swift
//  gather-in
//
//  Created by Ramzy on 12/02/2021.
//

import Foundation
import Alamofire

enum CreateGroupRequest: URLRequestBuilder {
    case getDepartmentMembers(departmentId:String, token:String)
    
    case addGroup(departmentId: String, name:String, members:[String],token:String)
    
    var path: String {
        switch self {
        
        case .getDepartmentMembers:
            return "get-department-members"
            
        case .addGroup:
            return "add-group"
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getDepartmentMembers(let departmentId,let token):
            param["department_id"] = departmentId
            param["access_token"] = token
            
        case .addGroup(let departmentId,let name,let members,let token):
            param["department_id"] = departmentId
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
            
        case .addGroup:
            return .post
        }
    }
}
