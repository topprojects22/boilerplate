//
//  UserDetailsViewModel.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import Foundation

// MARK: - Presentation/ViewModels/UserDetailsViewModel.swift
@MainActor
class UserDetailsViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoading = false
    @Published var error: IdentifiableError?
    
    private let toggleFavoriteUseCase: ToggleFavoriteUserUseCase
    
    init(user: User, toggleFavoriteUseCase: ToggleFavoriteUserUseCase) {
        self.user = user
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }
    
    static func make(user: User, diContainer: DIContainerProtocol) -> UserDetailsViewModel {
        let useCase = ToggleFavoriteUserUseCase(repository: diContainer.makeUserRepository())
        return UserDetailsViewModel(user: user, toggleFavoriteUseCase: useCase)
    }
    
    func toggleFavorite() {
        Task {
            isLoading = true
            do {
                user = try await toggleFavoriteUseCase.execute(user: user)
            } catch {
                self.error = IdentifiableError(error: error)
            }
            isLoading = false
        }
    }
}
