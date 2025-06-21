import SwiftUI
import StoreKit

struct PaymentWallView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel = PaymentWallViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showFAQ = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 32) {
                    Text("Upgrade to Premium")
                        .font(.title).fontWeight(.bold)
//                    VStack(spacing: 16) {
//                        if let product = viewModel.products.first {
//                            Text(product.displayName)
//                                .font(.title2).fontWeight(.semibold)
//                            Text(product.description)
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
//                            VStack(spacing: 4) {
//                                Text(product.displayPrice)
//                                    .font(.system(size: 36, weight: .bold, design: .rounded))
//                                    .foregroundColor(.accentColor)
//                                if let offer = product.subscription?.introductoryOffer {
//                                    HStack(spacing: 6) {
//                                        Image(systemName: "tag.fill")
//                                            .foregroundColor(.green)
//                                        Text("Special offer: \(offer.localizedDescription)")
//                                            .font(.footnote)
//                                            .foregroundColor(.green)
//                                    }
//                                }
//                            }
//                            if let period = product.subscription?.subscriptionPeriod {
//                                Text("Billed every \(period.value) \(period.unit.localizedString())")
//                                    .font(.footnote)
//                                    .foregroundColor(.secondary)
//                            }
//                        } else {
//                            ProgressView()
//                            Text("Loading subscription info...")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                        VStack(alignment: .leading, spacing: 12) {
//                            Text("Unlock all features:")
//                                .font(.headline)
//                            FeatureRow(icon: "checkmark.seal", text: "Unlimited transactions")
//                            FeatureRow(icon: "star.fill", text: "Priority support")
//                            FeatureRow(icon: "chart.bar", text: "Advanced analytics")
//                            FeatureRow(icon: "lock.shield", text: "Secure payment processing")
//                        }
//                        .padding(.leading)
//                    }
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 24)
//                            .fill(Color.white)
//                            .shadow(color: Color.black.opacity(0.07), radius: 12, x: 0, y: 4)
//                    )
                    // Testimonials Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What our users say")
                            .font(.headline)
                        TestimonialView(quote: "This app changed the way I manage my finances!", author: "— Alex R.")
                        TestimonialView(quote: "Premium is worth every penny. The analytics are top-notch.", author: "— Jamie L.")
                        TestimonialView(quote: "I love the clean design and easy payments.", author: "— Morgan S.")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 18).fill(Color.white).shadow(radius: 4))
                    // Comparison Table
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Compare Plans")
                            .font(.headline)
                        ComparisonTableView()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 18).fill(Color.white).shadow(radius: 4))
                    Button(action: {
                        viewModel.subscribe()
                    }) {
                        if viewModel.isSubscribing {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text(viewModel.products.first?.displayPrice ?? "Subscribe Now")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.accentColor))
                    .foregroundColor(.white)
                    .font(.headline)
                    .disabled(viewModel.isSubscribing || viewModel.products.isEmpty)
                    .padding(.horizontal)
                    if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "lock.shield")
                            .foregroundColor(.accentColor)
                        Text("Secure payment via Apple")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                    DisclosureGroup(isExpanded: $showFAQ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• You can cancel anytime in your Apple ID settings.")
                            Text("• Payment will be charged to your Apple ID account at confirmation of purchase.")
                            Text("• Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.")
                            Text("• Premium features are available immediately after purchase.")
                            Text("• If you cancel, you can still use Premium until the end of the billing period.")
                            Text("• Need help? Contact our support team from the Profile tab.")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    } label: {
                        Text("Frequently Asked Questions")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.accentColor)
                    }
                    .padding(.top, 8)
                }
                .padding(32)
            }
        }
        .onChange(of: viewModel.purchased) { purchased in
            if purchased {
                appState.currentScreen = .mainTab
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            Text(text)
        }
    }
}

struct TestimonialView: View {
    let quote: String
    let author: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\"\(quote)\"")
                .italic()
                .font(.body)
            Text(author)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

struct ComparisonTableView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("")
                Spacer()
                Text("Free")
                    .fontWeight(.semibold)
                Spacer()
                Text("Premium")
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 4)
            Divider()
            ComparisonRow(label: "Transactions", free: "Limited", premium: "Unlimited")
            ComparisonRow(label: "Support", free: "Standard", premium: "Priority")
            ComparisonRow(label: "Analytics", free: "Basic", premium: "Advanced")
            ComparisonRow(label: "Security", free: "Standard", premium: "Enhanced")
        }
    }
}

struct ComparisonRow: View {
    let label: String
    let free: String
    let premium: String
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(free)
                .foregroundColor(.gray)
            Spacer()
            Text(premium)
                .foregroundColor(.accentColor)
        }
        .padding(.vertical, 2)
    }
}

private extension Product.SubscriptionPeriod.Unit {
    func localizedString() -> String {
        switch self {
        case .day: return "day"
        case .week: return "week"
        case .month: return "month"
        case .year: return "year"
        @unknown default: return "period"
        }
    }
} 
