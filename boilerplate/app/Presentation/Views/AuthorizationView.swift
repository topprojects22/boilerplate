import SwiftUI

struct AuthorizationView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel = AuthorizationViewModel.make(diContainer: diContainer)
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            VStack(spacing: 32) {
                Text(viewModel.isRegistering ? "Register" : "Login")
                    .font(.title).fontWeight(.bold)
                VStack(spacing: 16) {
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(radius: 2))
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(radius: 2))
                }
                Button(action: {
                    if viewModel.isRegistering {
                        viewModel.register()
                    } else {
                        viewModel.login()
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text(viewModel.isRegistering ? "Register" : "Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.accentColor))
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top)
                .disabled(viewModel.isLoading)
                Button(action: { viewModel.isRegistering.toggle() }) {
                    Text(viewModel.isRegistering ? "Already have an account? Login" : "Don't have an account? Register")
                        .font(.footnote)
                        .foregroundColor(.accentColor)
                }
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            .padding(32)
        }
        .onChange(of: viewModel.isLoading) { isLoading in
            if !isLoading && viewModel.error == nil && (viewModel.email != "" && viewModel.password != "") {
                // Simulate successful login/register
                appState.currentScreen = .mainTab
            }
        }
    }
} 