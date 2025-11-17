//
//  LoginView.swift
//  messageApp
//
//  Created by mishima_lab     on 2025/11/17.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm = AuthViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("ログイン")
                .font(.largeTitle)

            TextField("ユーザー名", text: $vm.username)
                .textFieldStyle(.roundedBorder)

            SecureField("パスワード", text: $vm.password)
                .textFieldStyle(.roundedBorder)

            if let err = vm.errorMessage {
                Text(err).foregroundColor(.red)
            }

            Button("ログイン") {
                vm.login()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationDestination(isPresented: $vm.loginSuccess) {
            ChatListView(user: vm.username)
        }
    }
}
