//
//  TeacherNotficationRequest.swift
//  gather-in
//
//  Created by Ramzy on 11/02/2021.
//

import Foundation
import Alamofire

enum TeacherNotficationRequest: URLRequestBuilder {
    case getNotifications(teacherId: String, accessToken:String)

    
    var path: String {
        switch self {
        
        case .getNotifications:
            return "get-teacher-notification"

        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getNotifications(let teacherId, let accessToken):
            param["teacher_id"] = teacherId
            param["access_token"] = accessToken
        }

        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .getNotifications:
            return .post

        }
    }
}

