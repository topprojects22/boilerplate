//
//  AuthService.swift
//  boilerplate
//
//  Created by ark on 08.05.2025.
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> AuthResponse
    func register(email: String, password: String) async throws -> AuthResponse
}

class AuthService: AuthServiceProtocol {
    func login(email: String, password: String) async throws -> AuthResponse {
        print("3")
        guard let url = URL(string: "https://api.example.com/login") else {
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let message = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["error"] as? String ?? "Login failed"
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: message])
        }
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
    func register(email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: "https://api.example.com/register") else {
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
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
}
