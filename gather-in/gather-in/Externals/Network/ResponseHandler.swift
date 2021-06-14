//
//  ResponseHandler.swift
//  gather-in
//
//  Created by Ramzy on 14/01/2021.
//

import Foundation
import Alamofire


protocol HandleRequestResponse {
    func handleResponse<T: CodableInit>(_ response: DataResponse<Data>, completion: CallResponse<T>)
}

extension HandleRequestResponse {
    func handleResponse<T: CodableInit>(_ response: DataResponse<Data>, completion: CallResponse<T>) {
        switch response.result {
        case .failure(let error):
            completion?(ServerResponse<T>.failure(error))
        case .success(let value):
            do {
                let modules = try T(data: value)
                completion?(ServerResponse<T>.success(modules))
            } catch {
                completion?(ServerResponse<T>.failure(error))
            }
        }
    }
}
