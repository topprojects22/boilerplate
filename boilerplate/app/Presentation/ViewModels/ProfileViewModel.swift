import Foundation

class ProfileViewModel: ObservableObject {
    @Published var userName: String = "Marco Rivera"
    @Published var email: String = "marco.rivera@email.com"
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private var userRepository: UserRepository?
    
    init(userRepository: UserRepository? = nil) {
        self.userRepository = userRepository
    }
    
    static func make(diContainer: DIContainerProtocol) -> ProfileViewModel {
        ProfileViewModel(userRepository: diContainer.makeUserRepository())
    }
    
    func loadUserInfo() {
        // Stub: Add user info loading logic here
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
    
    func logout() {
        // Stub: Add logout logic here
    }
}