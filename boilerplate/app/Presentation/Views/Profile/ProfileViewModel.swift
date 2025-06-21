import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    
    /* Profile STATE */
    @Published var userName: String = "Marco Rivera"
    @Published var email: String = "marco.rivera@email.com"
    @Published var isLoading: Bool = false
    @Published var error: IdentifiableError?
    @Published var profile: Profile?
    /* !Profile STATE */
    
    /* Profile DI */
    private var profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    static func make(diContainer: DIContainerProtocol) -> ProfileViewModel {
        ProfileViewModel(profileRepository: diContainer.makeProfileRepository())
    }
    /* !Profile DI */
    
    /* Profile ACTIONS */
    func loadProfileInfo() {
        Task {
            isLoading = true
            do {
                profile = try await profileRepository.fetchProfile()
            } catch {
                self.error = IdentifiableError(error: error)
            }
            isLoading = false
        }
    }
    /* !Profile ACTIONS */
}
