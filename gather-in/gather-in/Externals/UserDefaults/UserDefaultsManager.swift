//
//  UserDefaultsManager.swift
//  gather-in
//
//  Created by Ramzy on 12/4/20.
//

import Foundation

class UserDefaultsManager: UserDefaultsProtocols {
    func saveString(_ string: String?, key: UserDefaultsKeys) {
        UserDefaults.standard.set(string, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func getString(key: UserDefaultsKeys) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    
    func saveBool(_ bool: Bool?, key: UserDefaultsKeys) {
        UserDefaults.standard.set(bool, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func getBool(key: UserDefaultsKeys) -> Bool? {
        return  UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    func saveInt(_ int: Int?, key: UserDefaultsKeys) {
         UserDefaults.standard.set(int, forKey: key.rawValue)
         UserDefaults.standard.synchronize()
     }
    
    func getInt(key: UserDefaultsKeys) -> Int? {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    func removeObject(key: UserDefaultsKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}
