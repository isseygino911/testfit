//
//  SignUpView.swift
//  testfit
//
//  Sign up screen with registration form
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Binding var showSignUp: Bool

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false

    // Validation states
    @State private var fullNameError: String?
    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var confirmPasswordError: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)

                    Text("Create Account")
                        .font(.system(size: 28, weight: .bold, design: .rounded))

                    Text("Sign up to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)

                // Form
                VStack(spacing: 20) {
                    // Full Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)

                            TextField("Enter your full name", text: $fullName)
                                .textContentType(.name)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(fullNameError != nil ? Color.red : Color.clear, lineWidth: 1)
                        )

                        if let error = fullNameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

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
                                TextField("Create a password", text: $password)
                            } else {
                                SecureField("Create a password", text: $password)
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

                    // Confirm Password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)

                            SecureField("Confirm your password", text: $confirmPassword)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(confirmPasswordError != nil ? Color.red : Color.clear, lineWidth: 1)
                        )

                        if let error = confirmPasswordError {
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

                // Sign Up button
                Button {
                    Task {
                        await performSignUp()
                    }
                } label: {
                    HStack {
                        if authManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Create Account")
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

                // Login link
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.secondary)

                    Button("Sign In") {
                        authManager.clearError()
                        showSignUp = false
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

        // Full name validation
        if fullName.isEmpty {
            fullNameError = "Full name is required"
            isValid = false
        } else if fullName.count < 2 {
            fullNameError = "Name must be at least 2 characters"
            isValid = false
        } else {
            fullNameError = nil
        }

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
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
            isValid = false
        } else {
            passwordError = nil
        }

        // Confirm password validation
        if confirmPassword.isEmpty {
            confirmPasswordError = "Please confirm your password"
            isValid = false
        } else if confirmPassword != password {
            confirmPasswordError = "Passwords do not match"
            isValid = false
        } else {
            confirmPasswordError = nil
        }

        return isValid
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // MARK: - Sign Up
    private func performSignUp() async {
        guard validateForm() else { return }

        let success = await authManager.signUp(
            email: email,
            password: password,
            fullName: fullName
        )

        if success {
            // Navigation will happen automatically through AuthManager
        }
    }
}

#Preview {
    SignUpView(showSignUp: .constant(true))
}
