//
//  GetPlansResponse.swift
//  gather-in
//
//  Created by Ramzy on 15/01/2021.
//

import Foundation

struct GetPlansResponse: CodableInit {
    let status: Bool
    let message: String
    let data: [GetPlansDataResponse]?
}


struct GetPlansDataResponse: CodableInit {
    let name, cost, maxDepartments, maxGroups: String
    let currency: String
    let usersNumber: Int
    let planId : String?

    enum CodingKeys: String, CodingKey {
        case name, cost
        case maxDepartments = "max-departments"
        case maxGroups = "max-groups"
        case currency
        case usersNumber = "users_number"
        case planId = "plan_id"
    }
}

