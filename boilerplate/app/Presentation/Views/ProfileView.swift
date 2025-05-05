import SwiftUI

struct ProfileView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel: ProfileViewModel

    init() {
        _viewModel = StateObject(wrappedValue: ProfileViewModel.make(diContainer: DIContainer.shared))
    }

    var body: some View {
        VStack(spacing: 24) {
            // User Info
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                Text(viewModel.userName)
                    .font(.title2).fontWeight(.bold)
                Text(viewModel.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 24).fill(Color.white).shadow(radius: 4))
            // Actions/Settings
            VStack(spacing: 0) {
                ProfileActionRow(icon: "creditcard", title: "Payment Methods")
                Divider()
                ProfileActionRow(icon: "gearshape", title: "Settings")
                Divider()
                ProfileActionRow(icon: "questionmark.circle", title: "Help & Support")
                Divider()
                ProfileActionRow(icon: "arrow.right.square", title: "Logout", isDestructive: true)
            }
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
            Spacer()
        }
        .padding(.top)
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.loadUserInfo()
        }
    }
}

struct ProfileActionRow: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isDestructive ? .red : .accentColor)
            Text(title)
                .foregroundColor(isDestructive ? .red : .primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
    }
} 