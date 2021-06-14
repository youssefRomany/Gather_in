//
//  CreateDepartmentResponse.swift
//  gather-in
//
//  Created by Ramzy on 09/02/2021.
//

import Foundation

struct CreateDepartmentResponse: CodableInit {
    let status: Bool
    let message: String
    let data: String?
}
