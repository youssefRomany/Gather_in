//
//  GroupResultsResponse.swift
//  gather-in
//
//  Created by Ramzy on 10/02/2021.
//

import Foundation


struct GroupResultsResponse: CodableInit {
    let status: Bool
    let message: String
    let data: [GroupResultsDataResponse]?
}

struct GroupResultsDataResponse: CodableInit {
    let id: GroupResultsIdDataResponse
    let name: String
    let answers: Int
}

struct GroupResultsIdDataResponse: CodableInit {
    let id, name: String
    let leader: String?
    let students: [GroupResultsStudentDataResponse]
}

struct GroupResultsStudentDataResponse: CodableInit {
    let id, username: String
    let leader: Bool?
}
