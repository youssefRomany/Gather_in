//
//  StudentSettingsResponseModel.swift
//  gather-in
//
//  Created by Ramzy on 12/12/20.
//

import Foundation

struct StudentSettingsResponseModel: Decodable {
    var items: [StudentSettingsItemsDataModel]?
}


struct StudentSettingsItemsDataModel: Decodable {
    var id: Int?
    var title: String?
    var titleAr: String?
}
