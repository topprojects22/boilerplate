import SwiftUI

struct HomeView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel: HomeViewModel
    @State private var selectedTab = 0
    @State private var isRefreshing = false
    
    init() {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel.make(diContainer: DIContainer.shared)
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Enhanced Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back,")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(viewModel.userName)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        HStack(spacing: 16) {
                            Button(action: {}) {
                                Image(systemName: "bell")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .overlay(
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 8, height: 8)
                                            .offset(x: 4, y: -4)
                                    )
                            }
                            Button(action: {}) {
                                Image(systemName: "gearshape")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    
                    // Quick Stats
                    HStack(spacing: 16) {
                        StatCard(title: "Balance", value: "$\(String(format: "%.2f", viewModel.balance))", icon: "dollarsign.circle.fill", color: .blue)
                        StatCard(title: "Growth", value: "+2.45%", icon: "chart.line.uptrend.xyaxis", color: .green)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Quick Actions
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        QuickActionButton(title: "Send", icon: "arrow.up.circle.fill", color: .blue)
                        QuickActionButton(title: "Receive", icon: "arrow.down.circle.fill", color: .green)
                        QuickActionButton(title: "Invest", icon: "chart.pie.fill", color: .purple)
                        QuickActionButton(title: "Exchange", icon: "arrow.left.arrow.right.circle.fill", color: .orange)
                    }
                    .padding(.horizontal)
                }
                
                // Performance Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Performance")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Picker("Time Range", selection: $selectedTab) {
                            Text("1D").tag(0)
                            Text("1W").tag(1)
                            Text("1M").tag(2)
                            Text("1Y").tag(3)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                    }
                    
                    // Performance Graph
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .frame(height: 200)
                            .overlay(
                                VStack {
                                    Text("$\(String(format: "%.2f", viewModel.balance))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("Total Portfolio Value")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            )
                            .shadow(radius: 2)
                        
                        // Performance Metrics
                        HStack(spacing: 20) {
                            MetricCard(title: "Daily Change", value: "+$123.45", change: "1", isPositive: true)
                            MetricCard(title: "Weekly Change", value: "+$456.78", change: "1", isPositive: true)
                            MetricCard(title: "Monthly Change", value: "-$89.12", change: "1", isPositive: true)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Latest News Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Latest News")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Button("See All") {
                            // Action
                        }
                        .foregroundColor(.accentColor)
                    }
                    
                    VStack(spacing: 12) {
                        ForEach(viewModel.news) { item in
                            NewsCard(item: item)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Activity")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 12) {
                        ForEach(0..<3) { _ in
                            ActivityRow()
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .refreshable {
            isRefreshing = true
            await viewModel.loadData()
            isRefreshing = false
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

// MARK: - Supporting Views
//struct StatCard: View {
//    let title: String
//    let value: String
//    let icon: String
//    let color: Color
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Image(systemName: icon)
//                    .foregroundColor(color)
//                Text(title)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            Text(value)
//                .font(.title3)
//                .fontWeight(.bold)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//    }
//}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(width: 80, height: 80)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}

struct NewsCard: View {
    let item: NewsItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text.fill")
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 40, height: 40)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("2 hours ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ActivityRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Payment Sent")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("To John Doe")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("-$50.00")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("2 hours ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 
