//
//  AuthViewModel.swift
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var loginSuccess = false
    @Published var errorMessage: String?

    private let baseURL = URL(string: "http://localhost:3000")!

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            self.errorMessage = "入力してください"
            return
        }

        let url = baseURL.appendingPathComponent("login")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["username": username, "password": password]
        req.httpBody = try? JSONEncoder().encode(body)

        Task {
            do {
                let (_, response) = try await URLSession.shared.data(for: req)
                let http = response as! HTTPURLResponse

                await MainActor.run {
                    if http.statusCode == 200 {
                        self.loginSuccess = true
                    } else {
                        self.errorMessage = "ログイン失敗"
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "通信エラー"
                }
            }
        }
    }
}
