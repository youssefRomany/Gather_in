//
//  UpdatePlansRequest.swift
//  gather-in
//
//  Created by Ahmed Muhammed on 3/9/21.
//

import Foundation
import Alamofire

enum UpdatePlansRequest: URLRequestBuilder {
    case updatePlans(teacherId:String,planId: String,token: String)
    
    var path: String {
        switch self {
        
        case .updatePlans:
            return "update-teacher"
            
        }
    }
    
    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .updatePlans(let teacherId ,let planId, let token):
            param["teacher_id"] = teacherId
            param["subscription"] = planId
            param["access_token"] = token
        }
        
        return param
    }
    
    var method: HTTPMethod {
        switch self {
        
        case .updatePlans:
            return .post
        }
    }
}

