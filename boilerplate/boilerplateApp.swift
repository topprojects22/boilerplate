//
//  boilerplateApp.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import SwiftUI

@main
struct MyAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environment(\.diContainer, DIContainer.shared)
                .onAppear {
                    NotificationManager.shared.requestAuthorization { granted in
                        print("Notification permission granted: \(granted)")
                        if granted {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                    }
                }
        }
    }
}

class AppState: ObservableObject {
    enum Screen {
        case splash, auth, paywall, mainTab, profile
    }
    @Published var currentScreen: Screen = .splash
}

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    let isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
    
    var body: some View {
        ZStack {
            switch appState.currentScreen {
            case .splash:
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            if (isAuthenticated) {
                                appState.currentScreen = .mainTab
                            } else {
                                appState.currentScreen = .auth
                            }
                        }
                    }
            case .auth:
                AuthorizationView()
            case .paywall:
                PaymentWallView()
            case .mainTab:
                MainTabView()
            case .profile:
                ProfileView()
            }
            
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            PaymentsView()
                .tabItem {
                    Image(systemName: "arrow.left.arrow.right")
                    Text("Payments")
                }
                .tag(1)
            AnalyticsView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Analytics")
                }
                .tag(2)
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(3)
        }
    }
}
