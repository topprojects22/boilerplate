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
    @ObservedObject var viewModel: UserListViewModel
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            List(viewModel.users, id: \.id) { user in
                // Переход на детальный экран при нажатии
                NavigationLink(value: user) {
                    Text(user.name)
                }
            }
            .navigationTitle("Пользователи")
            .onAppear {
                viewModel.loadUsers()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("Ошибка"), message: Text(error.localizedDescription))
            }
        }
    }
}
