//
//  UserRepository.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

/// Протокол для работы с пользователями
protocol UserRepositoryProtocol {
    /// Получить список пользователей
    func fetchUsers() async throws -> [User]
}

// MARK: - Domain/Repositories/UserRepository.swift
extension UserRepositoryProtocol {
    func toggleFavorite(user: User) async throws -> User {
        // По умолчанию — заглушка
        return user
    }
}

class UserRepository: UserRepositoryProtocol {
    private let networkService: UserNetworkService
    private let localStore: UserLocalStore
    
    init(networkService: UserNetworkService, localStore: UserLocalStore) {
        self.networkService = networkService
        self.localStore = localStore
    }
    
    func fetchUsers() async throws -> [User] {
        let networkUsers = try await networkService.fetchUsers()
        let localUsers = localStore.fetchAll()
        
        // Слияние данных: сохраняем избранный статус
        return networkUsers.map { user in
            let isFavorite = localUsers.first(where: { $0.id == user.id })?.isFavorite ?? false
            return User(id: user.id, name: user.name, email: user.email, isFavorite: isFavorite)
        }
    }
    
    func toggleFavorite(user: User) async throws -> User {
        let updatedUser = User(id: user.id, name: user.name, email: user.email, isFavorite: !user.isFavorite)
        localStore.save(user: updatedUser)
        return updatedUser
    }
}
