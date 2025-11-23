//
//  HomeView.swift
//  testfit
//
//  Protected home screen after authentication
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authManager = AuthManager.shared

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Welcome Section
                VStack(spacing: 16) {
                    // User avatar
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 100, height: 100)

                        Text(getInitials())
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    }

                    VStack(spacing: 8) {
                        Text("Welcome back!")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        Text(authManager.currentUser?.fullName ?? "User")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                    }

                    Text(authManager.currentUser?.email ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)

                // Quick Stats Card
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.blue)
                        Text("Your Progress")
                            .font(.headline)
                        Spacer()
                    }

                    HStack(spacing: 20) {
                        StatCard(title: "Tests", value: "0", icon: "doc.text.fill", color: .blue)
                        StatCard(title: "Score", value: "--", icon: "star.fill", color: .orange)
                        StatCard(title: "Rank", value: "--", icon: "trophy.fill", color: .yellow)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)

                // Action Buttons
                VStack(spacing: 16) {
                    ActionButton(
                        title: "Start Practice Test",
                        subtitle: "Begin a new mock test session",
                        icon: "play.fill",
                        color: .blue
                    ) {
                        // TODO: Navigate to test selection
                    }

                    ActionButton(
                        title: "View History",
                        subtitle: "Check your past test results",
                        icon: "clock.fill",
                        color: .green
                    ) {
                        // TODO: Navigate to history
                    }

                    ActionButton(
                        title: "Study Materials",
                        subtitle: "Access learning resources",
                        icon: "book.fill",
                        color: .purple
                    ) {
                        // TODO: Navigate to materials
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            authManager.logout()
                        } label: {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                    }
                }
            }
        }
    }

    private func getInitials() -> String {
        guard let fullName = authManager.currentUser?.fullName else { return "?" }
        let components = fullName.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.prefix(2)
        return String(initials).uppercased()
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct ActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

#Preview {
    HomeView()
}
