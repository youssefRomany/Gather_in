//
//  TeacherSettingsResponseModel.swift
//  gather-in
//
//  Created by Ramzy on 10/01/2021.
//

import Foundation
struct TeacherSettingsResponseModel: Decodable {
    var items: [TeacherSettingsItemsDataModel]?
}


struct TeacherSettingsItemsDataModel: Decodable {
    var id: Int?
    var title: String?
    var titleAr: String?
}
