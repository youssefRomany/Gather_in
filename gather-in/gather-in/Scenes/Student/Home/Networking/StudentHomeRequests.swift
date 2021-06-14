//
//  StudentHomeRequests.swift
//  gather-in
//
//  Created by Ramzy on 05/02/2021.
//

import Foundation
import Alamofire

enum StudentHomeRequests: URLRequestBuilder {
    case getStudentDepartments(studentId: String, accessToken:String)

    
    var path: String {
        switch self {
        
        case .getStudentDepartments:
            return "get-student-departments"

        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getStudentDepartments(let studentId, let accessToken):
            param["student_id"] = studentId
            param["access_token"] = accessToken
        }

        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .getStudentDepartments:
            return .post

        }
    }
}

