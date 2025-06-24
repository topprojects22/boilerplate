//
//  AuthService.swift
//  boilerplate
//
//  Created by ark on 08.05.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case decodingFailed
    case unauthorized
    case unknown
}

protocol AuthNetworkServiceProtocol {
    func login(email: String, password: String) async throws -> AuthTokens
    func register(email: String, password: String) async throws -> AuthTokens
    func refresh(refreshToken: String) async throws -> AuthTokens
}

class AuthNetworkService: AuthNetworkServiceProtocol {
    func login(email: String, password: String) async throws -> AuthTokens {
        guard let url = URL(string: "http://localhost:4000/auth/login") else {
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            let message = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["error"] as? String ?? "Login failed"
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: message])
        }

        return try JSONDecoder().decode(AuthTokens.self, from: data)
    }
    func register(email: String, password: String) async throws -> AuthTokens {
        guard let url = URL(string: "http://localhost:4000/auth/register") else {
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let message = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["error"] as? String ?? "Registration failed"
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: message])
        }
        return try JSONDecoder().decode(AuthTokens.self, from: data)
    }
    
    func refresh(refreshToken: String) async throws -> AuthTokens {
            guard let url = URL(string: "http://localhost:4000/auth/refresh") else {
                throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body = ["refresh_token": refreshToken]
            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            if httpResponse.statusCode == 401 {
                throw NetworkError.unauthorized
            }

            return try JSONDecoder().decode(AuthTokens.self, from: data)
        }
}
