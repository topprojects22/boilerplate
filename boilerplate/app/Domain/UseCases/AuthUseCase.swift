import Foundation

class AuthUseCase {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        try await authService.login(email: email, password: password)
    }
    
    func register(email: String, password: String) async throws -> AuthResponse {
        try await authService.register(email: email, password: password)
    }
}
