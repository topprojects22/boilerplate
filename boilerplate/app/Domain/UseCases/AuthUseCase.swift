import Foundation

class AuthUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        try await authRepository.login(email: email, password: password)
    }
    
    func register(email: String, password: String) async throws -> AuthResponse {
        try await authRepository.register(email: email, password: password)
    }
}
