//
//  ChatIDTeacher&Leader.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 3/28/21.
//

import Foundation
import Alamofire

enum ChatIDTeacherAndLeaderResponse: URLRequestBuilder {
   
    case getChatID(groupId:String,teacherId:String,leaderId:String,typeChat:String)
    
    var path: String {
        switch self {
        
        case .getChatID:
            return "getChatIds"

        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getChatID(let groupId, let teacherId,let leaderId ,let typeChat ):
            param["groupId"] = groupId
            param["teacherId"] = teacherId
            param["leaderId"] = leaderId
            param["typeChat"] = typeChat
        }

        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .getChatID:
            return .post

        }
    }
}
