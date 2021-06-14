//
//  DepartmentGroupsRequest.swift
//  gather-in
//
//  Created by Ramzy on 06/02/2021.
//

import Foundation
import Alamofire

enum DepartmentGroupsRequest: URLRequestBuilder {
    case getDepartmentGroups(studentId: String, accessToken:String, departmentId: String)

    
    var path: String {
        switch self {
        
        case .getDepartmentGroups:
            return "get-department-groups"

        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getDepartmentGroups(let studentId, let accessToken, let departmentId):
            param["student_id"] = studentId
            param["access_token"] = accessToken
            param["department_id"] = departmentId
        }

        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .getDepartmentGroups:
            return .post

        }
    }
}

