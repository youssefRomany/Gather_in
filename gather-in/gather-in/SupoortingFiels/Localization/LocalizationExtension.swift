//
//  LocalizationExtension.swift
//  gather-in
//
//  Created by Ramzy on 12/4/20.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
