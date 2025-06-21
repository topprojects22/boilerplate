import Foundation
import StoreKit

class PaymentWallViewModel: ObservableObject {
    @Published var isSubscribing: Bool = false
    @Published var error: String?
    @Published var products: [Product] = []
    @Published var purchased: Bool = false
    
    private let productID = "your_monthly_subscription_product_id" // Replace with your real product ID
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        Task {
            do {
                let storeProducts = try await Product.products(for: [productID])
                DispatchQueue.main.async {
                    self.products = storeProducts
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = "Failed to fetch products: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func subscribe() {
        guard let product = products.first else {
            self.error = "Subscription product not available."
            return
        }
        isSubscribing = true
        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(_):
                        DispatchQueue.main.async {
                            self.purchased = true
                            self.isSubscribing = false
                        }
                    case .unverified(_, let error):
                        DispatchQueue.main.async {
                            self.error = "Purchase could not be verified: \(error.localizedDescription)"
                            self.isSubscribing = false
                        }
                    }
                case .userCancelled:
                    DispatchQueue.main.async {
                        self.isSubscribing = false
                    }
                case .pending:
                    DispatchQueue.main.async {
                        self.isSubscribing = false
                        self.error = "Purchase is pending."
                    }
                @unknown default:
                    DispatchQueue.main.async {
                        self.isSubscribing = false
                        self.error = "Unknown purchase result."
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = "Purchase failed: \(error.localizedDescription)"
                    self.isSubscribing = false
                }
            }
        }
    }
} 