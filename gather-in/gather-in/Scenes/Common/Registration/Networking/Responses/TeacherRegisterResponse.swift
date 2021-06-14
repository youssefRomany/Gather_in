//
//  TeacherRegisterResponse.swift
//  gather-in
//
//  Created by Ramzy on 14/01/2021.
//

import Foundation

struct TeacherRegisterResponse: CodableInit {
    let status: Bool
    let message : String
    let data: TeacherRegisterDataResponse?
    let emailAlreadyExists: Bool?
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case status, message, data , emailAlreadyExists
        case accessToken = "access_token"
    }
}


struct TeacherRegisterDataResponse: CodableInit {
    let id: String
    let name: String
    let email: String
}
