//
//  PlansRequest.swift
//  gather-in
//
//  Created by Ramzy on 15/01/2021.
//

import Foundation
import Alamofire

enum PlansRequest: URLRequestBuilder {
    case getPlans(token:String)
    
    
    var path: String {
        switch self {
        
        case .getPlans:
            return "get-plans"
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .getPlans(let token):
            param["access_token"] = token
        }
        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .getPlans:
            return .post
            
        }
    }
}
