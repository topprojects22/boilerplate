//
//  User.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

/// Сущность пользователя
struct User: Identifiable, Equatable, Codable, Hashable {
    let id: Int
    let name: String
    let email: String
    var isFavorite: Bool = false
}
