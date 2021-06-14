//
//  StudentDepartmentsResponse.swift
//  gather-in
//
//  Created by Ramzy on 05/02/2021.
//

import Foundation

struct StudentDepartmentsResponse: CodableInit {
    let status: Bool
    let message : String
    let data: [StudentDepartmentsDataResponse]?

}

struct StudentDepartmentsDataResponse: CodableInit {
    let id: String?
    let name: String?
    let code: String?
    let url: String?
    let teacher: String?
    let teacherName: String?
    let subscription: String?
    let groups : [StudentDepartmentGroupsData]?
    let members: [StudentDepartmentMembersData]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, code , url, teacher, subscription
        case groups
        case members
        case teacherName = "teacher_name"
    }
    
}

struct StudentDepartmentGroupsData: CodableInit {
    let id: String?
    let name: String?
}

struct StudentDepartmentMembersData: CodableInit {
    let id: String?
    let username: String
}
