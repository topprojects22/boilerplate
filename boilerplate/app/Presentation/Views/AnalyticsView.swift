import SwiftUI

struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()
    @State private var selectedTimeRange = 0
    @State private var selectedChartType = 0
    @State private var isRefreshing = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with Key Metrics
                VStack(spacing: 16) {
                    HStack {
                        Text("Analytics")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    // Key Metrics
                    HStack(spacing: 16) {
                        MetricCard(title: "Total Revenue", value: "$12,345", change: "+12.5%", isPositive: true)
                        MetricCard(title: "Active Users", value: "1,234", change: "+8.2%", isPositive: true)
                        MetricCard(title: "Conversion", value: "3.2%", change: "-1.5%", isPositive: false)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Time Range Selector
                VStack(alignment: .leading, spacing: 16) {
                    Text("Time Range")
                        .font(.headline)
                    
                    Picker("Time Range", selection: $selectedTimeRange) {
                        Text("1D").tag(0)
                        Text("1W").tag(1)
                        Text("1M").tag(2)
                        Text("1Y").tag(3)
                        Text("All").tag(4)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Main Chart
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Revenue Overview")
                            .font(.headline)
                        Spacer()
                        Picker("Chart Type", selection: $selectedChartType) {
                            Text("Line").tag(0)
                            Text("Bar").tag(1)
                            Text("Area").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(height: 200)
                    } else if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .frame(height: 200)
                    } else {
                        // Enhanced Chart
                        GeometryReader { geometry in
                            ZStack {
                                // Background Grid
                                VStack(spacing: 0) {
                                    ForEach(0..<5) { _ in
                                        Divider()
                                        Spacer()
                                    }
                                    Divider()
                                }
                                
                                // Chart
                                Path { path in
                                    let width = geometry.size.width
                                    let height = geometry.size.height
                                    let points = viewModel.chartData
                                    guard points.count > 1 else { return }
                                    
                                    let stepX = width / CGFloat(points.count - 1)
                                    let maxY = (points.max() ?? 1)
                                    let minY = (points.min() ?? 0)
                                    let rangeY = maxY - minY == 0 ? 1 : maxY - minY
                                    
                                    for (i, value) in points.enumerated() {
                                        let x = CGFloat(i) * stepX
                                        let y = height - ((CGFloat(value - minY) / CGFloat(rangeY)) * height)
                                        
                                        if i == 0 {
                                            path.move(to: CGPoint(x: x, y: y))
                                        } else {
                                            path.addLine(to: CGPoint(x: x, y: y))
                                        }
                                    }
                                }
                                .stroke(Color.accentColor, lineWidth: 3)
                                
                                // Gradient Fill
                                Path { path in
                                    let width = geometry.size.width
                                    let height = geometry.size.height
                                    let points = viewModel.chartData
                                    guard points.count > 1 else { return }
                                    
                                    let stepX = width / CGFloat(points.count - 1)
                                    let maxY = (points.max() ?? 1)
                                    let minY = (points.min() ?? 0)
                                    let rangeY = maxY - minY == 0 ? 1 : maxY - minY
                                    
                                    path.move(to: CGPoint(x: 0, y: height))
                                    
                                    for (i, value) in points.enumerated() {
                                        let x = CGFloat(i) * stepX
                                        let y = height - ((CGFloat(value - minY) / CGFloat(rangeY)) * height)
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                    
                                    path.addLine(to: CGPoint(x: width, y: height))
                                    path.closeSubpath()
                                }
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.accentColor.opacity(0.2), Color.accentColor.opacity(0.0)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                        }
                        .frame(height: 200)
                        .padding(.vertical)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Additional Analytics Sections
                VStack(spacing: 24) {
                    // User Demographics
                    AnalyticsSection(
                        title: "User Demographics",
                        content: {
                            HStack(spacing: 16) {
                                DemographicsCard(title: "Age", data: [
                                    ("18-24", 0.3),
                                    ("25-34", 0.4),
                                    ("35-44", 0.2),
                                    ("45+", 0.1)
                                ])
                                DemographicsCard(title: "Gender", data: [
                                    ("Male", 0.45),
                                    ("Female", 0.55)
                                ])
                            }
                        }
                    )
                    
                    // Top Performing Items
                    AnalyticsSection(
                        title: "Top Performing Items",
                        content: {
                            VStack(spacing: 12) {
                                ForEach(0..<3) { _ in
                                    TopItemRow()
                                }
                            }
                        }
                    )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .refreshable {
            isRefreshing = true
            await viewModel.loadAnalytics()
            isRefreshing = false
        }
        .onAppear {
            viewModel.loadAnalytics()
        }
    }
}

// MARK: - Supporting Views
struct MetricCard: View {
    let title: String
    let value: String
    let change: String
    let isPositive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            HStack(spacing: 4) {
                Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                Text(change)
            }
            .font(.caption)
            .foregroundColor(isPositive ? .green : .red)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AnalyticsSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
            
            content()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

struct DemographicsCard: View {
    let title: String
    let data: [(String, Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            VStack(spacing: 8) {
                ForEach(data, id: \.0) { item in
                    HStack {
                        Text(item.0)
                            .font(.caption)
                        Spacer()
                        Text("\(Int(item.1 * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.accentColor.opacity(0.2))
                            .frame(width: geometry.size.width * CGFloat(item.1))
                    }
                    .frame(height: 4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TopItemRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.accentColor.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "star.fill")
                        .foregroundColor(.accentColor)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Product Name")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("Category")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$1,234")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("+12.5%")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Preview
struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
} 