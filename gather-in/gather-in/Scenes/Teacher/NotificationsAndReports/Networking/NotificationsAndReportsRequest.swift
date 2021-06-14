//
//  NotificationsAndReportsRequest.swift
//  gather-in
//
//  Created by Ramzy on 12/02/2021.
//

import Foundation
import Alamofire


enum NotificationsAndReportsRequest: URLRequestBuilder {
    case getTeacherGroups(teacherId: String, accessToken:String)

    var path: String {
        switch self {
        
        case .getTeacherGroups:
            return "get-teacher-groups"
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getTeacherGroups(let teacherId, let accessToken):
            param["teacher_id"] = teacherId
            param["access_token"] = accessToken
        
        }
        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .getTeacherGroups:
            return .post

        }
    }
}


