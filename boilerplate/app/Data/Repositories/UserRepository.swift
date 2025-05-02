//
//  UserRepository.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

/// Протокол для работы с пользователями
protocol UserRepository {
    /// Получить список пользователей
    func fetchUsers() async throws -> [User]
}

// MARK: - Domain/Repositories/UserRepository.swift
extension UserRepository {
    func toggleFavorite(user: User) async throws -> User {
        // По умолчанию — заглушка
        return user
    }
}
