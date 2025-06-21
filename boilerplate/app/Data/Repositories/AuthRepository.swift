//
//  AuthRepository.swift
//  boilerplate
//
//  Created by ark on 08.05.2025.
//

protocol AuthRepository {
    func login(email: String, password: String) async throws -> AuthResponse
    func register(email: String, password: String) async throws -> AuthResponse
}
