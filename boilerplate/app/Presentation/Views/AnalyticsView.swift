import SwiftUI

struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()
    var body: some View {
        VStack {
            Spacer()
            Text("Analytics")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            } else {
                // Simple chart placeholder
                GeometryReader { geometry in
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
                    .background(RoundedRectangle(cornerRadius: 24).fill(Color.white).shadow(radius: 8))
                }
                .frame(height: 200)
                .padding()
            }
            Spacer()
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.loadAnalytics()
        }
    }
} 