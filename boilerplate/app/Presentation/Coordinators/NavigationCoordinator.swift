//
//  NavigationCoordinator.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

// MARK: - Presentation/Coordinators/NavigationCoordinator.swift
import SwiftUI
import Combine

/// Координатор для навигации в SwiftUI
class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    /// Перейти к детальному экрану пользователя
    func showUserDetails(user: User) {
        path.append(user)
    }
    
    /// Вернуться назад
    func goBack() {
        path.removeLast()

    }
    
    /// Перейти на главный экран
    func reset() {
        path = NavigationPath()
    }
    
    func goTo(_ route: Screen) {
        path.append(route)
    }
}
