//
//  ChatListsView.swift
//  messageApp
//
//  Created by mishima_lab     on 2025/11/17.
//

import Foundation
import Combine      // ObservableObject Protocol

class ChatListViewModel: ObservableObject {
    @Published var rooms: [ChatRoom] = []

    private let baseURL = URL(string: "http://localhost:3000")!

    func loadRooms() {
        let url = baseURL.appendingPathComponent("rooms")

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode([ChatRoom].self, from: data)
                await MainActor.run { self.rooms = decoded }
            } catch {
                print("Failed to load rooms:", error)
            }
        }
    }
}
