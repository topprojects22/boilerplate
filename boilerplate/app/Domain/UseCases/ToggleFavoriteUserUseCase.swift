//
//  ToggleFavoriteUserUseCase.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//


// MARK: - Domain/UseCases/ToggleFavoriteUserUseCase.swift
class ToggleFavoriteUserUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(user: User) async throws -> User {
        try await repository.toggleFavorite(user: user)
    }
}