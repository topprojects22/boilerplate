//
//  FetchUsersUseCase.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

/// UseCase для получения списка пользователей
class FetchUsersUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    /// Выполнить загрузку пользователей
    func execute() async throws -> [User] {
        try await repository.fetchUsers()
    }
}
