//
//  AuthRepositoryImpl.swift
//  boilerplate
//
//  Created by ark on 08.05.2025.
//

import Foundation
import Combine

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> AuthTokens
    func refresh(refreshToken: String) async throws -> AuthTokens
    func logout() async throws -> Void
    func keychainLoad() async throws -> AuthTokens?
    func register(email: String, password: String) async throws -> AuthTokens
}

class AuthRepository: AuthRepositoryProtocol {
    private let networkService: AuthNetworkService
    private let keychainService: KeychainService
    // private let realmService: RealmService
    
    init(networkService: AuthNetworkService, keychainService: KeychainService) {
        self.networkService = networkService
        self.keychainService = keychainService
    }
    
    func login(email: String, password: String) async throws -> AuthTokens {
        let authTokens = try await networkService.login(email: email, password: password)
        try keychainService.save(tokens: authTokens)
        return authTokens
    }
    
    func refresh(refreshToken: String) async throws -> AuthTokens {
        let refreshTokens = try await networkService.refresh(refreshToken: refreshToken)
        try keychainService.save(tokens: refreshTokens)
        return refreshTokens
    }
    
    func logout() async throws -> Void {
        print("Logout")
        keychainService.clear()
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
    }
    
    func keychainLoad() async throws -> AuthTokens? {
        return try keychainService.load()
    }
    
    func setIsAuthenticated(isAuthenticated: Bool) -> Void {
        UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
    }
    
    func register(email: String, password: String) async throws -> AuthTokens {
        let authTokens = try await networkService.register(email: email, password: password)
        try keychainService.save(tokens: authTokens)
        return authTokens
    }
}
