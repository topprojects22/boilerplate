import SwiftUI

struct HomeView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel = HomeViewModel.make(diContainer: diContainer)

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Greeting and profile
                HStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text("Hello 👋,")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(viewModel.userName)
                            .font(.headline)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal)
                // Notification test button
                Button(action: {
                    NotificationManager.shared.scheduleNotification(
                        title: "Test Notification",
                        body: "This is a test notification from your app.",
                        inSeconds: 5
                    )
                }) {
                    Label("Send Test Notification", systemImage: "bell.badge")
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor))
                        .foregroundColor(.white)
                }
                // Performance Graph (placeholder)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Performance")
                        .font(.headline)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(height: 160)
                        .overlay(Text("[Graph]").foregroundColor(.gray))
                }
                .padding(.horizontal)
                // Total Balance
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Balance")
                        .font(.headline)
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("$\(String(format: "%.2f", viewModel.balance))")
                            .font(.largeTitle).fontWeight(.bold)
                        Text("+2.45%")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 24).fill(Color.white).shadow(radius: 4))
                .padding(.horizontal)
                // Latest News
                VStack(alignment: .leading, spacing: 12) {
                    Text("Latest News")
                        .font(.headline)
                    VStack(spacing: 8) {
                        ForEach(viewModel.news) { item in
                            HStack {
                                Image(systemName: "doc.text")
                                    .foregroundColor(.accentColor)
                                Text(item.title)
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5)))
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 24).fill(Color.white).shadow(radius: 4))
                .padding(.horizontal)
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.loadData()
        }
    }
} 