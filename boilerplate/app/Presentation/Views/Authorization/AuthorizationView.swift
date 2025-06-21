import SwiftUI

struct AuthorizationView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel: AuthorizationViewModel
    @EnvironmentObject var appState: AppState
    
    init() {
        _viewModel = StateObject(wrappedValue: AuthorizationViewModel.make(diContainer: DIContainer.shared))
    }
    
    
    var body: some View {
        ZStack {
            AppBackgroundView()

                        VStack(spacing: 20) {
                            Image(systemName: "wind") // Иконка, как в дизайне
                                .font(.system(size: 60))
                                .foregroundColor(Color.appAccent)
                                .padding(.bottom, 30)

                            Text("Вход в систему")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.appPrimaryText)

                            AppCardView {
                                VStack(spacing: 15) {
                                    TextField("Email", text: $viewModel.email)
                                        .textFieldStyle(AppTextFieldStyle())
                                        .textContentType(.emailAddress)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)

                                    SecureField("Пароль", text: $viewModel.password)
                                        .textFieldStyle(AppTextFieldStyle())
                                        .textContentType(.password)
                                    
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .padding(.top, 10)
                                    } else {
                                        Button("Войти") {
                                            // Действие при нажатии кнопки входа
                                            print("Email: \(viewModel.email), Password: \(viewModel.password)")
                                            // Здесь можно добавить логику аутентификации [^2]
                                            viewModel.isLoading = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                viewModel.isLoading = false
                                                // Обработка результата входа
                                            }
                                        }
                                        .buttonStyle(AppButtonStyle())
                                        .padding(.top, 10)
                                    }
                                }
                            }
                            .padding(.horizontal)


                            HStack {
                                Button("Забыли пароль?") {
                                    // Действие для восстановления пароля
                                }
                                .foregroundColor(Color.appAccent)
                                .font(.footnote)

                                Spacer()

                                Button("Создать аккаунт") {
                                    // Действие для регистрации
                                }
                                .foregroundColor(Color.appAccent)
                                .font(.footnote)
                            }
                            .padding(.horizontal, 30)
                            
                            Spacer()
                        }
                        .padding(.top, 50)
        }
        // .onOpenURL(perform: { url in
        //   Task {
        //     do {
        //       // Пример обработки deep link для OAuth, если используется Supabase [^2]
        //       // try await supabase.auth.session(from: url)
        //     } catch {
        //       // обработка ошибки
        //     }
        //   }
        // })
    }
} 

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
