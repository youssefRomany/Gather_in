//
//  StudentRegisterResponse.swift
//  gather-in
//
//  Created by Ramzy on 14/01/2021.
//

import Foundation

struct RegisterResponse: Codable {
    
    let status: Bool?
    let token : String?
    let userId: Int?
    let token_expires: String?
    let kind: String?
}
