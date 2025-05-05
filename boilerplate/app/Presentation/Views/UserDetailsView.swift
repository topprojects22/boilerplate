//
//  UserDetailsView.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import SwiftUI

struct UserDetailsView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel: UserDetailsViewModel
    
    init(user: User) {
        let toggleFavoriteUseCase = ToggleFavoriteUserUseCase(repository: DIContainer.shared.makeUserRepository())
        _viewModel = StateObject(wrappedValue: UserDetailsViewModel(user: user, toggleFavoriteUseCase: toggleFavoriteUseCase))
    }
    
    var body: some View {
        VStack {
            Text(viewModel.user.name)
                .font(.largeTitle)
            
            Button(action: {
                viewModel.toggleFavorite()
            }) {
                HStack {
                    Image(systemName: viewModel.user.isFavorite ? "star.fill" : "star")
                    Text(viewModel.user.isFavorite ? "Удалить из избранного" : "Добавить в избранное")
                }
                .foregroundColor(.yellow)
            }
        }
        .padding()
        .navigationTitle("Детали")
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Ошибка"), message: Text(error.localizedDescription))
        }
    }
}
