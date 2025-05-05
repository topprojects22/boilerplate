import SwiftUI

struct SplashView: View {
    @Environment(\.diContainer) private var diContainer
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            VStack(spacing: 24) {
                Image(systemName: "bolt.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.accentColor)
                    .background(Circle().fill(Color.white).shadow(radius: 10))
                Text("MyWallet")
                    .font(.largeTitle).fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
    }
} 