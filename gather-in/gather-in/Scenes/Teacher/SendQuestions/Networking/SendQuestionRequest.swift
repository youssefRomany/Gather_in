//
//  SendQuestionRequest.swift
//  gather-in
//
//  Created by Ramzy on 11/02/2021.
//

import Foundation
import Alamofire


enum SendQuestionRequest: URLRequestBuilder {
    case getTeacherGroups(teacherId: String, accessToken:String)
    
    case sendQuestion(groups: [String], year: String, month: String, day: String, hour: String, minute: String, sender: String, questionBody: String, type:String, choices:[String]?, accessToken:String)
   
    var path: String {
        switch self {
        
        case .getTeacherGroups:
            return "get-teacher-groups"
            
        case .sendQuestion:
            return "send-question"

        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getTeacherGroups(let teacherId, let accessToken):
            param["teacher_id"] = teacherId
            param["access_token"] = accessToken
        
        case .sendQuestion(let groups, let year, let month, let day, let hour, let minute,let sender, let questionBody,let  type,let choices,let accessToken):
            param["groups"] = groups
            param["year"] = year
            param["month"] = month
            param["day"] = day
            param["hour"] = hour
            param["minute"] = minute
            param["sender"] = sender
            param["questionBody"] = questionBody
            param["type"] = type
            if choices != nil {
                param["choices"] = choices
            }
            param["access_token"] = accessToken
        }

        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .getTeacherGroups:
            return .post
            
        case .sendQuestion:
            return .post

        }
    }
}


