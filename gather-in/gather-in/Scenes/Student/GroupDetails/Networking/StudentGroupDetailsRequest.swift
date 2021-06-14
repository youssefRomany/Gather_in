//
//  StudentGroupDetailsRequest.swift
//  gather-in
//
//  Created by Ramzy on 06/02/2021.
//

import Foundation
import Alamofire

enum StudentGroupDetailsRequest: URLRequestBuilder {
    case getGroup(accessToken:String, groupId: String)

    
    var path: String {
        switch self {
        
        case .getGroup:
            return "get-group"

        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getGroup(let accessToken, let groupId):
            param["access_token"] = accessToken
            param["group_id"] = groupId
        }

        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .getGroup:
            return .post

        }
    }
}
