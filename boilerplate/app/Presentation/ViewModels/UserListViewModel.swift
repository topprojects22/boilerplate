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
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var error: IdentifiableError?
    
    private let fetchUsersUseCase: FetchUsersUseCase
    private let navigationCoordinator: NavigationCoordinator
    
    init(
        fetchUsersUseCase: FetchUsersUseCase,
        navigationCoordinator: NavigationCoordinator
    ) {
        self.fetchUsersUseCase = fetchUsersUseCase
        self.navigationCoordinator = navigationCoordinator
    }
    
    /// Загрузить пользователей
    func loadUsers() {
        Task {
            isLoading = true
            error = nil
            
            do {
                users = try await fetchUsersUseCase.execute()
            } catch {
                self.error = IdentifiableError(error: error)
            }
            
            isLoading = false
        }
    }
}
