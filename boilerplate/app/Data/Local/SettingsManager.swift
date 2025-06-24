//
//  UserDefaults.swift
//  ar3dprofile
//
//  Created by ark on 24.06.2025.
//
import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    private init() {}
    
    var isAuthenticated: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isAuthenticated")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isAuthenticated")
        }
    }
}
