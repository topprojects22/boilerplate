//
//  DIContainer.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import CoreData
import SwiftUI

protocol DIContainerProtocol {
    func makeUserRepository() -> UserRepository
    func makeAuthUseCase() -> AuthUseCase
    // Add more as needed
}

class DIContainer: DIContainerProtocol {
    static let shared: DIContainerProtocol = DIContainer()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "UserModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error $error.userInfo)")
            }
        }
    }
    
    func makeUserRepository() -> UserRepository {
        let networkService = UserNetworkService()
        let localStore = UserLocalStore(container: persistentContainer)
        return UserRepositoryImpl(networkService: networkService, localStore: localStore)
    }
    
    func makeAuthUseCase() -> AuthUseCase {
        AuthUseCase(authRepository: AuthRepositoryImpl(authService: AuthService()))
    }
}

// MARK: - SwiftUI EnvironmentKey for DI
struct DIContainerKey: EnvironmentKey {
    static let defaultValue: DIContainerProtocol = DIContainer.shared
}

extension EnvironmentValues {
    var diContainer: DIContainerProtocol {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}

// MARK: - Mock for Previews/Tests

class UserRepositoryMock: UserRepository {
    func fetchUsers() async throws -> [User] {
        return [User(id: 1, name: "Mock User", email: "mock@example.com", isFavorite: false)]
    }
}
