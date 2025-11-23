//
//  AuthService.swift
//  testfit
//
//  Network service for authentication API calls
//

import Foundation

enum AuthError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError
    case serverError(String)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return error.localizedDescription
        case .decodingError:
            return "Failed to process server response"
        case .serverError(let message):
            return message
        case .unauthorized:
            return "Invalid credentials"
        }
    }
}

class AuthService {
    static let shared = AuthService()

    // IMPORTANT: Change this to your backend server URL
    // For local development with simulator, use localhost
    // For physical device, use your computer's IP address
    private let baseURL = "http://localhost:3000/api"

    private init() {}

    // MARK: - Sign Up
    func signUp(email: String, password: String, fullName: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)/auth/signup") else {
            throw AuthError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": email,
            "password": password,
            "fullName": fullName
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.networkError(NSError(domain: "", code: -1))
            }

            let decoder = JSONDecoder()
            let authResponse = try decoder.decode(AuthResponse.self, from: data)

            if httpResponse.statusCode >= 400 {
                throw AuthError.serverError(authResponse.message)
            }

            return authResponse
        } catch let error as AuthError {
            throw error
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw AuthError.decodingError
        } catch {
            throw AuthError.networkError(error)
        }
    }

    // MARK: - Login
    func login(email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            throw AuthError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": email,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.networkError(NSError(domain: "", code: -1))
            }

            let decoder = JSONDecoder()
            let authResponse = try decoder.decode(AuthResponse.self, from: data)

            if httpResponse.statusCode >= 400 {
                throw AuthError.serverError(authResponse.message)
            }

            return authResponse
        } catch let error as AuthError {
            throw error
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw AuthError.decodingError
        } catch {
            throw AuthError.networkError(error)
        }
    }

    // MARK: - Get Current User
    func getCurrentUser(token: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/auth/me") else {
            throw AuthError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.networkError(NSError(domain: "", code: -1))
            }

            if httpResponse.statusCode == 401 {
                throw AuthError.unauthorized
            }

            let decoder = JSONDecoder()
            let userResponse = try decoder.decode(UserResponse.self, from: data)

            guard let userData = userResponse.data else {
                throw AuthError.serverError(userResponse.message ?? "Unknown error")
            }

            return userData.user
        } catch let error as AuthError {
            throw error
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw AuthError.decodingError
        } catch {
            throw AuthError.networkError(error)
        }
    }
}
