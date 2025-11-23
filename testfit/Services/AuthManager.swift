//
//  AuthManager.swift
//  testfit
//
//  Manages authentication state across the app
//

import Foundation
import SwiftUI

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let tokenKey = "auth_token"
    private let authService = AuthService.shared

    private init() {
        // Check for existing token on init
        checkAuthStatus()
    }

    // MARK: - Token Management
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    private func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }

    private func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }

    // MARK: - Check Auth Status
    func checkAuthStatus() {
        guard let token = getToken() else {
            isAuthenticated = false
            return
        }

        isLoading = true

        Task {
            do {
                let user = try await authService.getCurrentUser(token: token)
                self.currentUser = user
                self.isAuthenticated = true
            } catch {
                // Token is invalid or expired
                self.clearToken()
                self.isAuthenticated = false
                self.currentUser = nil
            }
            self.isLoading = false
        }
    }

    // MARK: - Sign Up
    func signUp(email: String, password: String, fullName: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await authService.signUp(
                email: email,
                password: password,
                fullName: fullName
            )

            if response.success, let data = response.data {
                saveToken(data.token)
                currentUser = data.user
                isAuthenticated = true
                isLoading = false
                return true
            } else {
                errorMessage = response.message
                isLoading = false
                return false
            }
        } catch let error as AuthError {
            errorMessage = error.errorDescription
            isLoading = false
            return false
        } catch {
            errorMessage = "An unexpected error occurred"
            isLoading = false
            return false
        }
    }

    // MARK: - Login
    func login(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await authService.login(
                email: email,
                password: password
            )

            if response.success, let data = response.data {
                saveToken(data.token)
                currentUser = data.user
                isAuthenticated = true
                isLoading = false
                return true
            } else {
                errorMessage = response.message
                isLoading = false
                return false
            }
        } catch let error as AuthError {
            errorMessage = error.errorDescription
            isLoading = false
            return false
        } catch {
            errorMessage = "An unexpected error occurred"
            isLoading = false
            return false
        }
    }

    // MARK: - Logout
    func logout() {
        clearToken()
        currentUser = nil
        isAuthenticated = false
    }

    // MARK: - Clear Error
    func clearError() {
        errorMessage = nil
    }
}
