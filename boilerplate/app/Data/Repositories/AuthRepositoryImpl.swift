//
//  AuthRepositoryImpl.swift
//  boilerplate
//
//  Created by ark on 08.05.2025.
//

import Foundation
import Combine

class AuthRepositoryImpl: AuthRepository {
    private let authService: AuthService
    // private let realmService: RealmService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        let authUser = try await authService.login(email: email, password: password)

        return authUser
    }
    
    func register(email: String, password: String) async throws -> AuthResponse {
        let registerUser = try await authService.register(email: email, password: password)

        return registerUser
    }
}
