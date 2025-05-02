//
//  boilerplateApp.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import SwiftUI

@main
struct MyAppApp: App {
    // Используем DIContainer для внедрения зависимостей
    private let userRepository = DIContainer.shared.makeUserRepository()
    
    private let navigationCoordinator = NavigationCoordinator()

    var body: some Scene {
        WindowGroup {
            // Создаем ViewModel с внедренными зависимостями
            let fetchUsersUseCase = FetchUsersUseCase(repository: userRepository)
            let viewModel = UserListViewModel(
                fetchUsersUseCase: fetchUsersUseCase,
                navigationCoordinator: navigationCoordinator
            )
            
            // Передаем ViewModel в начальный экран
            UserListView(viewModel: viewModel)
                .environmentObject(navigationCoordinator)
        }
    }
}
