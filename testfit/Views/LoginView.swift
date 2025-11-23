//
//  LoginView.swift
//  testfit
//
//  Login screen with email and password form
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Binding var showSignUp: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false

    // Validation states
    @State private var emailError: String?
    @State private var passwordError: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)

                    Text("Welcome Back")
                        .font(.system(size: 28, weight: .bold, design: .rounded))

                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)

                // Form
                VStack(spacing: 20) {
                    // Email field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)

                            TextField("Enter your email", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(emailError != nil ? Color.red : Color.clear, lineWidth: 1)
                        )

                        if let error = emailError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    // Password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)

                            if showPassword {
                                TextField("Enter your password", text: $password)
                            } else {
                                SecureField("Enter your password", text: $password)
                            }

                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(passwordError != nil ? Color.red : Color.clear, lineWidth: 1)
                        )

                        if let error = passwordError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal)

                // Error message from server
                if let errorMessage = authManager.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                // Login button
                Button {
                    Task {
                        await performLogin()
                    }
                } label: {
                    HStack {
                        if authManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign In")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(authManager.isLoading)
                .padding(.horizontal)
                .padding(.top, 10)

                // Sign up link
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.secondary)

                    Button("Sign Up") {
                        authManager.clearError()
                        showSignUp = true
                    }
                    .fontWeight(.semibold)
                }
                .padding(.top, 20)

                Spacer()
            }
        }
    }

    // MARK: - Validation
    private func validateForm() -> Bool {
        var isValid = true

        // Email validation
        if email.isEmpty {
            emailError = "Email is required"
            isValid = false
        } else if !isValidEmail(email) {
            emailError = "Please enter a valid email"
            isValid = false
        } else {
            emailError = nil
        }

        // Password validation
        if password.isEmpty {
            passwordError = "Password is required"
            isValid = false
        } else {
            passwordError = nil
        }

        return isValid
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // MARK: - Login
    private func performLogin() async {
        guard validateForm() else { return }

        let success = await authManager.login(email: email, password: password)

        if success {
            // Navigation will happen automatically through AuthManager
        }
    }
}

#Preview {
    LoginView(showSignUp: .constant(false))
}
