//
//  AuthContainerView.swift
//  testfit
//
//  Container view that manages auth flow and navigation
//

import SwiftUI

struct AuthContainerView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var showSignUp = false

    var body: some View {
        Group {
            if authManager.isLoading {
                // Loading state while checking auth
                LoadingView()
            } else if authManager.isAuthenticated {
                // User is authenticated - show home
                HomeView()
                    .transition(.opacity)
            } else {
                // User not authenticated - show login/signup
                if showSignUp {
                    SignUpView(showSignUp: $showSignUp)
                        .transition(.move(edge: .trailing))
                } else {
                    LoginView(showSignUp: $showSignUp)
                        .transition(.move(edge: .leading))
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authManager.isAuthenticated)
        .animation(.easeInOut(duration: 0.3), value: showSignUp)
    }
}

// MARK: - Loading View

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)

            Text("Loading...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    AuthContainerView()
}
