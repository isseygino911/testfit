//
//  User.swift
//  testfit
//
//  User model for authentication
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let fullName: String
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName
        case createdAt
    }
}

// API Response models
struct AuthResponse: Codable {
    let success: Bool
    let message: String
    let data: AuthData?
}

struct AuthData: Codable {
    let user: User
    let token: String
}

struct UserResponse: Codable {
    let success: Bool
    let data: UserData?
    let message: String?
}

struct UserData: Codable {
    let user: User
}
