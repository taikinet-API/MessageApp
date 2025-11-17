//
//  ChatListView.swift
//  messageApp
//
//  Created by mishima_lab     on 2025/11/17.
//

import SwiftUI

struct ChatListView: View {
    let user: String
    @StateObject private var vm = ChatListViewModel()

    var body: some View {
        List(vm.rooms) { room in
            NavigationLink(room.name) {
                ChatRoomView(room: room, user: user)
            }
        }
        .navigationTitle("チャット一覧")
        .onAppear {
            vm.loadRooms()
        }
    }
}
