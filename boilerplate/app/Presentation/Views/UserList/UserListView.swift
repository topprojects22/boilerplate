//
//  UserListView.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import SwiftUI
import Combine

/// Список пользователей
struct UserListView: View {
    @Environment(\.diContainer) private var diContainer
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    @StateObject private var viewModel: UserListViewModel
    @State private var searchText = ""
    @State private var selectedFilter = 0
    @State private var isRefreshing = false
    @State private var showingAddUser = false
    
//    init() {
//        let fetchUsersUseCase = FetchUsersUseCase(repository: DIContainer.shared.makeUserRepository())
//        let navigationCoordinator = NavigationCoordinator()
//        _viewModel = StateObject(wrappedValue: UserListViewModel(
//            fetchUsersUseCase: fetchUsersUseCase,
//            navigationCoordinator: navigationCoordinator
//        ))
//    }
    
    init() {
        let navigationCoordinator = NavigationCoordinator()
        _viewModel = StateObject(wrappedValue: UserListViewModel.make(navigationCoordinator: navigationCoordinator, diContainer: DIContainer.shared))
    }
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return viewModel.users
        }
        return viewModel.users.filter { user in
            user.name.localizedCaseInsensitiveContains(searchText) ||
            user.email.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            ScrollView {
                VStack(spacing: 24) {
                    // Search and Filter
                    VStack(spacing: 16) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search users...", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Filter Options
                        Picker("Filter", selection: $selectedFilter) {
                            Text("All").tag(0)
                            Text("Active").tag(1)
                            Text("Inactive").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    // User List
                    VStack(spacing: 16) {
                        HStack {
                            Text("Users")
                                .font(.headline)
                            Spacer()
                            Text("\(filteredUsers.count) total")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 200)
                        } else if filteredUsers.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "person.2.slash")
                                    .font(.system(size: 50))
                                    .foregroundColor(.secondary)
                                Text("No users found")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, minHeight: 200)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredUsers, id: \.id) { user in
                                    NavigationLink(value: user) {
                                        UserRow(user: user)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
            .navigationTitle("Users")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddUser = true }) {
                        Image(systemName: "person.badge.plus")
                            .font(.title3)
                    }
                }
            }
            .refreshable {
                isRefreshing = true
                await viewModel.loadUsers()
                isRefreshing = false
            }
            .sheet(isPresented: $showingAddUser) {
                AddUserView()
            }
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription))
            }
        }
        .onAppear {
            viewModel.loadUsers()
        }
    }
}

// MARK: - Supporting Views
struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 16) {
            // User Avatar
            Circle()
                .fill(Color.accentColor.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(user.initials)
                        .font(.headline)
                        .foregroundColor(.accentColor)
                )
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Status Indicator
            Circle()
                .fill(true ? Color.green : Color.gray)
                .frame(width: 12, height: 12)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AddUserView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Permissions")) {
                    Toggle("Active", isOn: .constant(true))
                    Toggle("Admin", isOn: .constant(false))
                }
            }
            .navigationTitle("Add User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Extensions
extension User {
    var initials: String {
        let components = name.components(separatedBy: " ")
        if components.count >= 2,
           let first = components.first?.first,
           let last = components.last?.first {
            return "\(first)\(last)"
        }
        return String(name.prefix(2))
    }
}

// MARK: - Preview
struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
