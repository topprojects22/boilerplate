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
    func makeProfileRepository() -> ProfileRepository
    func makeAuthRepository() -> AuthRepository
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
        return UserRepository(networkService: networkService, localStore: localStore)
    }
    
    func makeProfileRepository() -> ProfileRepository {
        let networkService = ProfileNetworkService()
        let localStore = UserLocalStore(container: persistentContainer)
        return ProfileRepository(networkService: networkService, localStore: localStore)
    }
    
    func makeAuthRepository() -> AuthRepository {
        let networkService = AuthNetworkService()
        let keychainService = KeychainService()
        return AuthRepository(networkService: networkService, keychainService: keychainService)
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
