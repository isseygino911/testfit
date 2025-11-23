//
//  SplashView.swift
//  testfit
//
//  App launch/splash screen with animated logo
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var showMainContent = false

    var body: some View {
        if showMainContent {
            AuthContainerView()
        } else {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    // App Icon/Logo
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 140, height: 140)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)

                        Image(systemName: "brain.head.profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                            .scaleEffect(isAnimating ? 1.0 : 0.8)
                    }

                    // App Name
                    VStack(spacing: 8) {
                        Text("TestFit")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Mock Test Playground")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .opacity(isAnimating ? 1 : 0)

                    // Loading indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                        .opacity(isAnimating ? 1 : 0)
                        .padding(.top, 40)
                }
            }
            .onAppear {
                // Start animations
                withAnimation(.easeInOut(duration: 0.8)) {
                    isAnimating = true
                }

                // Navigate to main content after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showMainContent = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
