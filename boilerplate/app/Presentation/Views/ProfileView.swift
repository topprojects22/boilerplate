import SwiftUI

struct ProfileView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel: ProfileViewModel
    @State private var selectedTab = 0
    @State private var isRefreshing = false
    
    init() {
        _viewModel = StateObject(wrappedValue: ProfileViewModel.make(diContainer: DIContainer.shared))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Enhanced Profile Header
                VStack(spacing: 16) {
                    // Profile Image and Name
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.accentColor)
                            .background(Color.accentColor.opacity(0.1))
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.accentColor, lineWidth: 2)
                            )
                        
                        VStack(spacing: 4) {
                            Text(viewModel.userName)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(viewModel.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Quick Stats
                    HStack(spacing: 16) {
                        StatCard(title: "Orders", value: "12", icon: "bag.fill", color: .blue)
                        StatCard(title: "Wishlist", value: "5", icon: "heart.fill", color: .red)
                        StatCard(title: "Reviews", value: "8", icon: "star.fill", color: .yellow)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Account Settings
                VStack(alignment: .leading, spacing: 16) {
                    Text("Account Settings")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ProfileActionRow(icon: "person.fill", title: "Personal Information", subtitle: "Update your profile details")
                        Divider()
                        ProfileActionRow(icon: "creditcard.fill", title: "Payment Methods", subtitle: "Manage your payment options")
                        Divider()
                        ProfileActionRow(icon: "bell.fill", title: "Notifications", subtitle: "Configure your notification preferences")
                        Divider()
                        ProfileActionRow(icon: "lock.fill", title: "Privacy & Security", subtitle: "Manage your account security")
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                
                // Preferences
                VStack(alignment: .leading, spacing: 16) {
                    Text("Preferences")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ProfileActionRow(icon: "globe", title: "Language", subtitle: "English (US)")
                        Divider()
                        ProfileActionRow(icon: "moon.fill", title: "Dark Mode", subtitle: "System Default")
                        Divider()
                        ProfileActionRow(icon: "textformat.size", title: "Text Size", subtitle: "Medium")
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                
                // Support & About
                VStack(alignment: .leading, spacing: 16) {
                    Text("Support & About")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ProfileActionRow(icon: "questionmark.circle.fill", title: "Help & Support", subtitle: "Get assistance")
                        Divider()
                        ProfileActionRow(icon: "info.circle.fill", title: "About", subtitle: "Version 1.0.0")
                        Divider()
                        ProfileActionRow(icon: "arrow.right.square.fill", title: "Logout", subtitle: "Sign out of your account", isDestructive: true)
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding()
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .refreshable {
            isRefreshing = true
            await viewModel.loadUserInfo()
            isRefreshing = false
        }
        .onAppear {
            viewModel.loadUserInfo()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ProfileActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var isDestructive: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isDestructive ? .red : .accentColor)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(isDestructive ? Color.red.opacity(0.1) : Color.accentColor.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isDestructive ? .red : .primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
} 