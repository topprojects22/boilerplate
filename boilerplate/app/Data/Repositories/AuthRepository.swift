//
//  AuthRepositoryImpl.swift
//  boilerplate
//
//  Created by ark on 08.05.2025.
//

import Foundation
import Combine

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> AuthResponse
    func register(email: String, password: String) async throws -> AuthResponse
}

class AuthRepository: AuthRepositoryProtocol {
    private let networkService: AuthNetworkService
    // private let realmService: RealmService
    
    init(networkService: AuthNetworkService) {
        self.networkService = networkService
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        let authUser = try await networkService.login(email: email, password: password)

        return authUser
    }
    
    func register(email: String, password: String) async throws -> AuthResponse {
        let registerUser = try await networkService.register(email: email, password: password)

        return registerUser
    }
}
