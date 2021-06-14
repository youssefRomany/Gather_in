//
//  TeacherNotificationsResponse.swift
//  gather-in
//
//  Created by Ramzy on 11/02/2021.
//

import Foundation

struct TeacherNotificationsResponse: CodableInit {
    let status: Bool
    let message: String
    let data: [TeacherNotificationsDataResponse]?
}


struct TeacherNotificationsDataResponse: CodableInit {
    let minute, month, hour, day, year: Int
    let text: String
}
