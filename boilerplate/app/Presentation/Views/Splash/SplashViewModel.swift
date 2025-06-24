import Foundation

@MainActor
class SplashViewModel: ObservableObject {
    /* Splash STATE */
    /* !Splash STATE */
    
    /* Splash DI */
    private var coordinator: NavigationCoordinator
    
    init(
        coordinator: NavigationCoordinator,
    ) {
        self.coordinator = coordinator
    }
    
    static func make(diContainer: DIContainerProtocol) -> SplashViewModel {
        SplashViewModel(
            coordinator: diContainer.makeCoordinator(),
        )
    }
    /* !Splash DI */
    
    /* Splash ACTIONS */
    func setNextScreen() {
        let isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        if isAuthenticated {
            coordinator.goTo(.mainTab)
            return
        }
        coordinator.goTo(.auth)
    }
    /* !Splash ACTIONS */
}
