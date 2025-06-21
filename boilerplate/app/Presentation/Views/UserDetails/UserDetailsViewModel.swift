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
    
    /* UserDetails STATE */
    @Published var user: User
    @Published var isLoading = false
    @Published var error: IdentifiableError?
    /* !UserDetails STATE */
    
    /* UserDetails DI */
    private let userRepository: UserRepository
    
    init(
        user: User,
        userRepository: UserRepository,
    ) {
        self.user = user
        self.userRepository = userRepository
    }
    
    static func make(user: User, diContainer: DIContainerProtocol) -> UserDetailsViewModel {
        UserDetailsViewModel(user: user, userRepository: diContainer.makeUserRepository())
    }
    /* !UserDetails DI */
    
    /* UserDetails ACTIONS */
    func toggleFavorite() {
        Task {
            isLoading = true
            do {
                user = try await userRepository.toggleFavorite(user: user)
            } catch {
                self.error = IdentifiableError(error: error)
            }
            isLoading = false
        }
    }
    /* !UserDetails ACTIONS */
}
