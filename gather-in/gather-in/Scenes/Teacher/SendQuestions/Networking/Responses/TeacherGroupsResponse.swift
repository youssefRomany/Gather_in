//
//  TeacherGroupsResponse.swift
//  gather-in
//
//  Created by Ramzy on 11/02/2021.
//

import Foundation

struct TeacherGroupsResponse: CodableInit {
    let status: Bool
    let message: String
    let data: [TeacherGroupsDataResponse]?
}

struct TeacherGroupsDataResponse: CodableInit {
    let id, name: String
    let leader: String?
    let students: [TeacherGroupsStudentDataResponse]
    var isSelected: Bool? = false
}

struct TeacherGroupsStudentDataResponse: CodableInit {
    let id, username: String
    let leader: Bool?
}
