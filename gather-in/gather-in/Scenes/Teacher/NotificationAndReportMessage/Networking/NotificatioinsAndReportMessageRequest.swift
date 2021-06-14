//
//  NotificatioinsAndReportMessageRequest.swift
//  gather-in
//
//  Created by Ramzy on 12/02/2021.
//

import Foundation
import Alamofire


enum NotificatioinsAndReportMessageRequest: URLRequestBuilder {
    
    case sendQuestion(groups: [String], year: String, month: String, day: String, hour: String, minute: String, text: String, accessToken:String)
   
    var path: String {
        switch self {
        
        case .sendQuestion:
            return "send-notification-to-groups"

        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {

        case .sendQuestion(let groups, let year, let month, let day, let hour, let minute,let text, let accessToken):
            param["groups"] = groups
            param["year"] = year
            param["month"] = month
            param["day"] = day
            param["hour"] = hour
            param["minute"] = minute
            param["text"] = text
            param["access_token"] = accessToken
        }

        return param
    }
    
    var method: HTTPMethod {
        switch self {


        case .sendQuestion:
            return .post

        }
    }
}


