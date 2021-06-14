//
//  TeacherChangePasswordRequest.swift
//  gather-in
//
//  Created by Ramzy on 13/02/2021.
//

import Foundation
import Alamofire

enum TeacherChangePasswordRequest: URLRequestBuilder {
    case updatePassword(teacherId:String,oldPassword: String,newPassword: String,email:String ,token: String)
    
    var path: String {
        switch self {
        
        case .updatePassword:
            return "update-teacher-password"
            
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .updatePassword(let teacherId ,let oldPassword, let newPassword, let email, let token):
            param["teacher_id"] = teacherId
            param["old_password"] = oldPassword
            param["new_password"] = newPassword
            param["email"] = email
            param["access_token"] = token
        }
        
        return param
    }
    
    var method: HTTPMethod {
        switch self {
        
        case .updatePassword:
            return .post
        }
    }
}
