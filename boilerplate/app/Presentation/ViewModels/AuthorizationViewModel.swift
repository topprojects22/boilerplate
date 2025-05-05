import Foundation

class AuthorizationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isRegistering: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    static func make(diContainer: DIContainerProtocol) -> AuthorizationViewModel {
        AuthorizationViewModel(authUseCase: diContainer.makeAuthUseCase())
    }
    
    func login() {
        isLoading = true
        error = nil
        Task {
            do {
                try await authUseCase.login(email: email, password: password)
                await MainActor.run {
                    SessionManager.shared.saveSession(token: response.token, user: response.user)
                    // Navigate or update UI
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                }
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func register() {
        isLoading = true
        error = nil
        Task {
            do {
                try await authUseCase.register(email: email, password: password)
                // Handle successful registration (e.g., update user state, navigate)
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                }
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
} 