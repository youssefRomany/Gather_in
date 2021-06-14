//
//  URLRequestBuilder.swift
//  gather-in
//
//  Created by Ramzy on 14/01/2021.
//

import Foundation
import Alamofire

protocol URLRequestBuilder: URLRequestConvertible,APIRequestHandler {
    var mainURL: URL { get }
    
    var requestURL: URL { get }

    var path: String { get }
    
    var headers: HTTPHeaders { get }

    var parameters: Parameters? { get }
    

    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get }
        
}

extension URLRequestBuilder {
    var mainURL: URL {
        return URL(string: Config.BASEURL)!
    }
    
    var requestURL: URL {
        return mainURL.appendingPathComponent(path)
    }
    
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers["language"] = "en"
        return headers
    }
    
    
    var defaultParams: Parameters {
        var param = Parameters()
        return param
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return request
    }
    
    
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }

}
