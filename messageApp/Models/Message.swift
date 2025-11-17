//
//  Message.swift
//


import Foundation

struct Message: Codable, Identifiable {
    let id: Int
    let user: String
    let text: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case user
        case text
        case createdAt = "created_at"
    }
}
