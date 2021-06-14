//
//  TeacherEditProfileRequest.swift
//  gather-in
//
//  Created by Ramzy on 13/02/2021.
//

import Foundation
import Alamofire

enum TeacherEditProfileRequest: URLRequestBuilder {
    case updateTeacher(teacherId:String,username: String,email: String,token: String)
    
    var path: String {
        switch self {
        
        case .updateTeacher:
            return "update-teacher"
            
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .updateTeacher(let teacherId ,let name, let email, let token):
            param["teacher_id"] = teacherId
            param["username"] = name
            param["email"] = email
            param["access_token"] = token
        }
        
        return param
    }
    
    var method: HTTPMethod {
        switch self {
        
        case .updateTeacher:
            return .post
        }
    }
}
