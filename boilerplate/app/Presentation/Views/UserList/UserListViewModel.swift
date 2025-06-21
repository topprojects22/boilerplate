//
//  UserListViewModel.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//


// MARK: - Presentation/ViewModels/UserListViewModel.swift
import Foundation

@MainActor
class UserListViewModel: ObservableObject {
    
    /* UserList STATE */
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var error: IdentifiableError?
    /* !UserList STATE */
    
    /* UserList DI */
    private let userRepository: UserRepository
    private let navigationCoordinator: NavigationCoordinator
    
    init(
        userRepository: UserRepository,
        navigationCoordinator: NavigationCoordinator
    ) {
        self.userRepository = userRepository
        self.navigationCoordinator = navigationCoordinator
    }
    
    static func make(navigationCoordinator: NavigationCoordinator, diContainer: DIContainerProtocol) -> UserListViewModel {
        UserListViewModel(userRepository: diContainer.makeUserRepository(), navigationCoordinator: navigationCoordinator)
    }
    /* !UserList DI */
    
    /* UserList ACTIONS */
    /// Загрузить пользователей
    func loadUsers() {
        Task {
            isLoading = true
            error = nil
            
            do {
                users = try await userRepository.fetchUsers()
            } catch {
                self.error = IdentifiableError(error: error)
            }
            
            isLoading = false
        }
    }
    /* !UserList ACTIONS */
}
