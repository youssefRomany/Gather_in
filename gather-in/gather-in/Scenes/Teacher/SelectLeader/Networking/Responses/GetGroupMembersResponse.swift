//
//  GetGroupMembersResponse.swift
//  gather-in
//
//  Created by Ramzy on 10/02/2021.
//

import Foundation

struct GetGroupMembersResponse: CodableInit {
    let status: Bool
    let message: String
    let data: [GetGroupMembersDataResponse]?
}

struct GetGroupMembersDataResponse: CodableInit {
    let id: String
    let username: String
    let leader: Bool?
}
