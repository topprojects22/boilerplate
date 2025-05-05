import Foundation

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

class HomeViewModel: ObservableObject {
    @Published var userName: String = "Marco Rivera"
    @Published var balance: Double = 180512.85
    @Published var performanceData: [Double] = [1, 2, 1.5, 2.2, 2, 2.5, 2.8]
    @Published var news: [NewsItem] = [
        NewsItem(title: "Exclusive offers now available on UDSRFBV cloud wallets", description: "Check out the latest features!"),
        NewsItem(title: "Discover new coins and features!", description: "Claim your reward today.")
    ]
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    // Placeholder for future repository/service
    private var homeRepository: Any?
    
    init(homeRepository: Any? = nil) {
        self.homeRepository = homeRepository
    }
    
    static func make(diContainer: DIContainerProtocol) -> HomeViewModel {
        // Replace Any? with a real repository when available
        HomeViewModel(homeRepository: nil)
    }
    
    func loadData() {
        // Stub: Add data loading logic here
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
} 