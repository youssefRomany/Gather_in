//
//  RegisterRequest.swift
//  gather-in
//
//  Created by Ramzy on 14/01/2021.
//

import Foundation

import Alamofire

enum RegisterRequest: URLRequestBuilder {
    case teacherSignup(username: String,email: String, password:String)
    case studentSignup(username: String,email: String, password: String)
    
    var path: String {
        switch self {
        
        case .teacherSignup:
            return "teacher-signup"
            
        case .studentSignup:
            return "student-signup"
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .teacherSignup(let username,let email, let password):
            param["username"] = username
            param["email"] = email
            param["password"] = password
            param["subscription"] = "plan-1"
            
        case .studentSignup(let username,let email, let password):
            param["username"] = username
            param["email"] = email
            param["password"] = password
        }
        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .teacherSignup:
            return .post
            
        case .studentSignup:
            return .post
        }
    }
    
    
}
