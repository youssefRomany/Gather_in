//
//  GroupMembersResponseModel.swift
//  gather-in
//
//  Created by Ramzy on 12/02/2021.
//

import Foundation

struct GroupMembersResponseModel: CodableInit {
    let status: Bool
    let message: String
    let data: [GroupMembersDataResponse]?
}

struct GroupMembersDataResponse: CodableInit {
    let id, username: String
}
