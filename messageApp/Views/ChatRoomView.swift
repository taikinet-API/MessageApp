//
//  ChatRoomView.swift
//  messageApp
//
//  Created by mishima_lab     on 2025/11/17.
//

import SwiftUI

struct ChatRoomView: View {
    let room: ChatRoom
    let user: String

    @StateObject private var vm = ChatRoomViewModel()

    @State private var input = ""

    var body: some View {
        VStack {
            List(vm.messages) { msg in
                VStack(alignment: .leading) {
                    Text(msg.user)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(msg.text)
                }
            }

            HStack {
                TextField("メッセージを入力", text: $input)
                    .textFieldStyle(.roundedBorder)

                Button("送信") {
                    vm.sendMessage(roomId: room.id, user: user, text: input)
                    input = ""
                }
            }
            .padding()
        }
        .navigationTitle(room.name)
        .onAppear {
            vm.loadMessages(roomId: room.id)
        }
    }
}
