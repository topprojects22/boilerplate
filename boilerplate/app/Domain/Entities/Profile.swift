//
//  Profile.swift
//  ar3dprofile
//
//  Created by ark on 21.06.2025.
//

/// Сущность пользователя
struct Profile: Identifiable, Equatable, Codable, Hashable {
    let id: Int
    let name: String
}
