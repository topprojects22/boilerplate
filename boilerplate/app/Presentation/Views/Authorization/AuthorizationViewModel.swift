import Foundation

@MainActor
class AuthorizationViewModel: ObservableObject {
    /* Authorization STATE */
    
    /// OLD
    @Published var email: String = "ark@yandex.ru"
    @Published var password: String = "qwe123!"
    @Published var isRegistering: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String?
    /// !OLD

    private(set) var accessToken: String?
    private(set) var refreshToken: String?
    
    private var isRefreshing = false
    private var refreshCompletionHandlers: [() -> Void] = []
    /* !Authorization STATE */
    
    /* Authorization DI */
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        
        Task {
            await restoreSession()
        }
    }
    
    static func make(diContainer: DIContainerProtocol) -> AuthorizationViewModel {
        AuthorizationViewModel(authRepository: diContainer.makeAuthRepository())
    }
    /* !Authorization DI */
    
    /* Authorization ACTIONS */
    
    func restoreSession() async {
        do {
            if let tokens = try await authRepository.keychainLoad() {
                let isoDate: String = tokens.expiresAt
                
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let date = formatter.date(from: isoDate)
                
                if date ?? Date() > Date() {
                    update(tokens: tokens)
                } else {
                
                    try await refreshTokens(tokens: tokens)
                }
            }
        } catch {
            print("Ошибка восстановления сессии: $error.localizedDescription)")
        }
    }

    func login(email: String, password: String) async throws {
        let tokens = try await authRepository.login(email: email, password: password)
        update(tokens: tokens)
    }

    func logout() async throws {
        try await authRepository.logout()

        accessToken = nil
        refreshToken = nil
    }

    func handleUnauthorized(completion: @escaping () -> Void) async {
        await withCheckedContinuation { continuation in
            refreshCompletionHandlers.append {
                continuation.resume()
            }

            if !isRefreshing {
                isRefreshing = true
                Task {
                    do {
                        // TODO ВЕРНУТЬ!!
                        // try await refreshTokens()
                        isRefreshing = false
                        for handler in refreshCompletionHandlers {
                            handler()
                        }
                        refreshCompletionHandlers.removeAll()
                    } catch {
                        isRefreshing = false
                        refreshCompletionHandlers.removeAll()
                    }
                    continuation.resume()
                }
            }
        }
        completion()
    }

    private func refreshTokens(tokens: AuthTokens?) async throws {
        guard let refreshToken = tokens?.refreshToken else {
            throw NetworkError.unauthorized
        }
        let newTokens = try await authRepository.refresh(refreshToken: refreshToken)
        update(tokens: newTokens)
    }

    private func update(tokens: AuthTokens) {
        self.accessToken = tokens.accessToken
        self.refreshToken = tokens.refreshToken

        setIsAuthenticated(isAuthenticated: true)
    }
    
    private func setIsAuthenticated(isAuthenticated: Bool) {
        authRepository.setIsAuthenticated(isAuthenticated: isAuthenticated)
    }
    
    /* !Authorization ACTIONS */
}
