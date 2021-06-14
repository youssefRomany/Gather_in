//
//  StudentProfileRequest.swift
//  gather-in
//
//  Created by Ramzy on 08/02/2021.
//

import Foundation
import Alamofire

enum StudentProfileRequest: URLRequestBuilder {
    case update(studentId:String,username: String?,email: String?,token: String)
    
    var path: String {
        switch self {
        
        case .update:
            return "update-student"
            
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .update(let studentId ,let name, let email, let token):
            if name != nil || name != ""{
                param["username"] = name
            }
            
            if email != nil || email != "" {
                param["email"] = email
            }
           
            param["student_id"] = studentId
            param["access_token"] = token
        }

        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .update:
            return .post
        }
    }
}
