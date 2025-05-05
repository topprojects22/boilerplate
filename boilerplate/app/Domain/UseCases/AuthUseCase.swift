import Foundation

protocol AuthenticationService {
    func login(email: String, password: String) async throws -> AuthResponse
    func register(email: String, password: String) async throws -> AuthResponse
}

class AuthUseCase {
    private let authService: AuthenticationService
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        try await authService.login(email: email, password: password)
    }
    
    func register(email: String, password: String) async throws -> AuthResponse {
        try await authService.register(email: email, password: password)
    }
}

class RealAuthenticationService: AuthenticationService {
    func login(email: String, password: String) async throws -> AuthResponse {
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

class MockAuthenticationService: AuthenticationService {
    func login(email: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if email == "test@example.com" && password == "password" {
            // Success
        } else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
        }
    }
    func register(email: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if email.contains("@") && password.count >= 6 {
            // Success
        } else {
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid registration data"])
        }
    }
} 