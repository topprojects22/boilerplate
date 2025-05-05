class SessionManager: ObservableObject {
    static let shared = SessionManager()
    @Published var token: String?
    @Published var user: UserSession?
    
    private init() {}
    
    func saveSession(token: String, user: UserSession) {
        self.token = token
        self.user = user
        // Optionally persist to Keychain/UserDefaults
    }
    
    func clearSession() {
        self.token = nil
        self.user = nil
    }
}