//
//  SelectLeaderRequests.swift
//  gather-in
//
//  Created by Ramzy on 10/02/2021.
//

import Foundation
import Alamofire

enum SelectLeaderRequests: URLRequestBuilder {
    case getGroupMembers(groupId: String, accessToken:String)
    case setLeader(groupId:String, leaderId:String, accessToken: String)

    
    var path: String {
        switch self {
        
        case .getGroupMembers:
            return "get-group-members"
            
        case .setLeader:
            return "set-leader"
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getGroupMembers(let groupId, let accessToken):
            param["group_id"] = groupId
            param["access_token"] = accessToken
            
            
        case .setLeader(let groupId, let leaderId, let accessToken):
            param["group_id"] = groupId
            param["leader_id"] = leaderId
            param["access_token"] = accessToken
        }
        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .getGroupMembers:
            return .post

        case .setLeader:
            return .post
        }
    }
}
