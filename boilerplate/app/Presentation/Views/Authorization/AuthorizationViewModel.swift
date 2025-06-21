import Foundation

@MainActor
class AuthorizationViewModel: ObservableObject {
    /* Authorization STATE */
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isRegistering: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String?
    /* !Authorization STATE */
    
    /* Authorization DI */
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    static func make(diContainer: DIContainerProtocol) -> AuthorizationViewModel {
        AuthorizationViewModel(authRepository: diContainer.makeAuthRepository())
    }
    /* !Authorization DI */
    
    /* Authorization ACTIONS */
    func login() {
        isLoading = true
        error = nil
        Task {
            do {
                var response = try await authRepository.login(email: email, password: password)
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
                try await authRepository.register(email: email, password: password)
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
    /* !Authorization ACTIONS */
}
