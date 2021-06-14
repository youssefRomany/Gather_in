//
//  DepartmentGroupsResponse.swift
//  gather-in
//
//  Created by Ramzy on 06/02/2021.
//

import Foundation

struct DepartmentGroupsResponse: CodableInit  {
    let status: Bool
    let message: String
    let data: [DepartmentGroupsDataResponse]?
}

struct DepartmentGroupsDataResponse: CodableInit {
    let id: String
    let name: DepartmentGroupNameData
    let inGroup: Bool
}

struct DepartmentGroupNameData: CodableInit {
    let id, name: String
}
