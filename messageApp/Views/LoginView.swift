//
//  LoginView.swift
//  messageApp
//
//  Created by mishima_lab     on 2025/11/17.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm = AuthViewModel()       // viewmodelの作成

    var body: some View {
        VStack(spacing: 20) {
            Text("ログイン")
                .font(.largeTitle)

            TextField("ユーザー名", text: $vm.username)      // viewmodelのユーザーフラグ
                .textFieldStyle(.roundedBorder)

            SecureField("パスワード", text: $vm.password)    // viewmodelのパスワードフラグ
                .textFieldStyle(.roundedBorder)

            if let err = vm.errorMessage {
                Text(err).foregroundColor(.red)
            }

            Button("ログイン") {                        // ログインが押されたら
                vm.login()                            // viewmodel内でログイン処理
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationDestination(isPresented: $vm.loginSuccess) {
            ChatListView(user: vm.username)
        }
    }
}
