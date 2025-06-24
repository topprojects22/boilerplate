import SwiftUI

struct SplashView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel: SplashViewModel
    
    @State private var isAnimating = false
    @State private var showLoadingText = false
    
    init() {
        _viewModel = StateObject(wrappedValue: SplashViewModel.make(diContainer: DIContainer.shared))
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.accentColor.opacity(0.2), Color(.systemBackground)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 32) {
                // Logo and App Name
                VStack(spacing: 24) {
                    // Animated Logo
                    ZStack {
                        // Outer Circle
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.accentColor.opacity(0.3), radius: 20, x: 0, y: 10)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        // Inner Circle
                        Circle()
                            .fill(Color.accentColor.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .scaleEffect(isAnimating ? 1.0 : 1.1)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        // Icon
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.accentColor)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .animation(
                                Animation.linear(duration: 2)
                                    .repeatForever(autoreverses: false),
                                value: isAnimating
                            )
                    }
                    
                    // App Name
                    VStack(spacing: 8) {
                        Text("MyWallet")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Your Financial Companion")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .opacity(showLoadingText ? 1 : 0)
                            .animation(.easeIn(duration: 0.5).delay(0.5), value: showLoadingText)
                    }
                }
                
                // Loading Indicator
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.2)
                        .tint(.accentColor)
                    
                    Text("Loading...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .opacity(showLoadingText ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.5), value: showLoadingText)
                }
                .padding(.top, 32)
            }
            .padding()
        }
        .onAppear {
            isAnimating = true
            showLoadingText = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                viewModel.setNextScreen()
            }
        }
    }
}

// MARK: - Preview
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
} 
