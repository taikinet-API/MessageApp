//
//  ChatRoomView.swift
//  messageApp
//
//  Created by mishima_lab     on 2025/11/17.
//

import SwiftUI

struct ChatRoomView: View {
    let room: ChatRoom      // room (from Models) id, name
    let user: String

    @StateObject private var vm = ChatRoomViewModel()   // instanceで保持しておくために @Stateobject を宣言

    @State private var input = ""   // 変数の場合は @State

    
    /*
     具体的なUIの中身
     */
    
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

#Preview {
    ChatRoomView(
        room: ChatRoom(id: 1, name: "テストルーム"),
        user: "previewUser"
    )
}
