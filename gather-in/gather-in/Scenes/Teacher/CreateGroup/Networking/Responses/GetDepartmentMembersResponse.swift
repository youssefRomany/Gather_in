//
//  GetDepartmentMembersResponse.swift
//  gather-in
//
//  Created by Ramzy on 12/02/2021.
//

import Foundation

struct GetDepartmentMembersResponse: CodableInit {
    let status: Bool
    let message: String
    let data: [GetDepartmentMembersDataResponse]?
}

struct GetDepartmentMembersDataResponse: CodableInit, Equatable, Hashable  {
    let id, username: String
    var isSelected: Bool? = false
}
