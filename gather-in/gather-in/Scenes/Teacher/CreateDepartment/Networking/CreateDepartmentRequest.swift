//
//  CreateDepartmentRequest.swift
//  gather-in
//
//  Created by Ramzy on 09/02/2021.
//

import Foundation
import Alamofire

enum CreateDepartmentRequest: URLRequestBuilder {
    case addDepartment(teacherId:String, name:String, code:String, token:String)
    
    
    var path: String {
        switch self {
        
        case .addDepartment:
            return "add-department-to-teacher"
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .addDepartment(let teacherId, let name, let code,let token):
            param["teacher_id"] = teacherId
            param["name"] = name
            param["code"] = code
            param["access_token"] = token
        }
        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .addDepartment:
            return .post
            
        }
    }
}
