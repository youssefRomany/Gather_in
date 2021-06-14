//
//  EditDepartmentRequest.swift
//  gather-in
//
//  Created by Ramzy on 09/02/2021.
//

import Foundation
import Alamofire

enum EditDepartmentRequest: URLRequestBuilder {
    case updateDepartment(departmentId:String, name:String, token:String)
    
    
    var path: String {
        switch self {
        
        case .updateDepartment:
            return "update-department"
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .updateDepartment(let departmentId, let name,let token):
            param["department_id"] = departmentId
            param["name"] = name
            param["access_token"] = token
        }
        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .updateDepartment:
            return .post
            
        }
    }
}

