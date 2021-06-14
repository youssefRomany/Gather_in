//
//  GroupResultsRequest.swift
//  gather-in
//
//  Created by Ramzy on 10/02/2021.
//

import Foundation
import Alamofire

enum GroupResultsRequest: URLRequestBuilder {
    case getResults(teacherId: String, accessToken:String)

    var path: String {
        switch self {
        
        case .getResults:
            return "get-groups-answers"
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getResults(let teacherId, let accessToken):
            param["teacher_id"] = teacherId
            param["access_token"] = accessToken
        }
        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .getResults:
            return .post
        }
    }
}
