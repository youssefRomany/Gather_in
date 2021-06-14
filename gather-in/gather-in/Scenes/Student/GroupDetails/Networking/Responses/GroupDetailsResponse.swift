//
//  GroupDetailsResponse.swift
//  gather-in
//
//  Created by Ramzy on 06/02/2021.
//

import Foundation


struct GroupDetailsResponse: CodableInit {
    let status: Bool
    let message: String
    let data: GroupDetailsDataResponse?
}


struct GroupDetailsDataResponse: CodableInit {
    let id, name, leader: String?
    let students: [GroupStudentData]
}


struct GroupStudentData: CodableInit {
    let id, username: String
    let leader: Bool?
}
