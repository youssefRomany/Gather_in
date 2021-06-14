//
//  BaseResponseModel.swift
//  gather-in
//
//  Created by Ramzy on 12/4/20.
//

import Foundation

struct BaseResponseModel: CodableInit {
    let status: Bool
    let message: String?
}
