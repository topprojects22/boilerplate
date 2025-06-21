import Foundation

struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let date: Date
}

class PaymentsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = [
        Transaction(title: "Coffee Shop", amount: -4.50, date: Date()),
        Transaction(title: "Salary", amount: 2000.00, date: Date()),
        Transaction(title: "Groceries", amount: -120.75, date: Date())
    ]
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    // Placeholder for future repository/service
    private var transactionRepository: Any?
    
    init(transactionRepository: Any? = nil) {
        self.transactionRepository = transactionRepository
    }
    
    static func make(diContainer: DIContainerProtocol) -> PaymentsViewModel {
        // Replace Any? with a real repository when available
        PaymentsViewModel(transactionRepository: nil)
    }
    
    func loadTransactions() {
        // Stub: Add loading logic here
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
} 