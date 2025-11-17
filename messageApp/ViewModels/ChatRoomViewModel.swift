//
//  ChatRoomViewModel.swift
//  messageApp
//
//  Created by mishima_lab     on 2025/11/17.
//

import Foundation
import Combine

class ChatRoomViewModel: ObservableObject {
    @Published var messages: [Message] = []

    private let baseURL = URL(string: "http://localhost:3000")!

    func loadMessages(roomId: Int) {
        let url = baseURL.appendingPathComponent("rooms/\(roomId)/messages")

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode([Message].self, from: data)
                await MainActor.run { self.messages = decoded }
            } catch {
                print("Failed:", error)
            }
        }
    }

    func sendMessage(roomId: Int, user: String, text: String) {
        let url = baseURL.appendingPathComponent("rooms/\(roomId)/messages")

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode([
            "user": user,
            "text": text
        ])

        Task {
            do {
                _ = try await URLSession.shared.data(for: req)
                loadMessages(roomId: roomId)
            } catch {
                print("Send error:", error)
            }
        }
    }
}
