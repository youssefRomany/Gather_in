//
//  User.swift
//  GarGor
//
//  Created by Mina Thabet on 22/07/2020.
//  Copyright © 2020 HardTask. All rights reserved.
//

import Foundation

class UserAccount: Codable{
    
    
    static let shared = UserAccount()

    var id: Int = 0
    var Token : String = ""
    var email : String = ""
    var isStudent = true
    var isLoggedIn = false

    
    init(){
        getStoredData()
    }
    
    func storeData(){
        sharedPref.shared.setSharedValue("id", value: self.id )
        sharedPref.shared.setSharedValue("Token", value: self.Token )
        sharedPref.shared.setSharedValue("isStudent", value: self.isStudent)
        sharedPref.shared.setSharedValue("email", value: self.email)
        sharedPref.shared.setSharedValue("isLoggedIn", value: self.isLoggedIn)

        getStoredData()

    }
    
     func getStoredData(){
        self.id = sharedPref.shared.getSharedValue(forKey: "id") as? Int ?? 0
        self.Token = sharedPref.shared.getSharedValue(forKey: "Token") as? String ?? ""
        self.isStudent = sharedPref.shared.getSharedValue(forKey: "isStudent") as? Bool ?? true
        self.isLoggedIn = sharedPref.shared.getSharedValue(forKey: "isLoggedIn") as? Bool ?? false
        self.email = sharedPref.shared.getSharedValue(forKey: "email") as? String ?? ""

    }
    
    func logout(){
        sharedPref.shared.removeValue(forKey: "id")
        sharedPref.shared.removeValue(forKey: "Token")
        sharedPref.shared.removeValue(forKey: "isStudent")
        sharedPref.shared.removeValue(forKey: "email")
        sharedPref.shared.removeValue(forKey: "isLoggedIn")
        getStoredData()
    }

}
