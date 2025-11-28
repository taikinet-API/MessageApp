//
//  AuthViewModel.swift
//  認証画面に関してのロジッククラス
//

import Foundation
import Combine   // @Published や ObservableObject に必要（SwiftUIでは自動importされるが明記はOK）

// ViewModel を SwiftUI の View が監視できるようにするためのクラス
class AuthViewModel: ObservableObject {         // ObservableObject = Viewに通知できる監視対象クラス

    // ------------------------------------------------------
    // 認証画面で扱う「状態（UIに反映させる値）」は @Published をつける
    // Published = 値が変わったときに View が自動で更新される
    // ------------------------------------------------------

    @Published var username = ""                // 入力されたユーザー名（双方向バインディングする）
    @Published var password = ""                // 入力されたパスワード（SecureFieldにバインド）
    @Published var loginSuccess = false         // ログイン判定。true になれば画面遷移が発生
    @Published var errorMessage: String?        // エラー内容を表示するためのプロパティ

    // ------------------------------------------------------
    // APIのベースURL（Node.jsサーバー）
    // private にすることで View から触れなくしている（情報隠蔽）
    // ------------------------------------------------------
    var baseURL = APIconfig.baseURL
    
    
    // ------------------------------------------------------
    // ログイン処理
    // ------------------------------------------------------
    func login() {

        // ----------------------------------------
        // 入力チェック
        // 空の場合は早期returnし、エラーだけ通知する
        // ----------------------------------------
        guard !username.isEmpty, !password.isEmpty else {
            self.errorMessage = "入力してください"
            return
        }

        // ----------------------------------------
        // POST /login のURLを作成
        // appendingPathComponent はURL結合専用
        // ----------------------------------------
        let url = baseURL.appendingPathComponent("login")

        // ----------------------------------------
        // URLRequestを生成し、HTTPメソッドやヘッダをセット
        // ----------------------------------------
        var req = URLRequest(url: url)
        req.httpMethod = "POST"                 // POSTメソッド（bodyを送るため）
        req.addValue("application/json",        // ボディの形式(Content-Type）をJSONに指定
                     forHTTPHeaderField: "Content-Type")

        // ----------------------------------------
        // ボディ（送信データ）をJSON形式にエンコード
        // username, password を辞書として送信
        // ----------------------------------------
        let body = ["username": username, "password": password]
        req.httpBody = try? JSONEncoder().encode(body)  // JSONデータに変換

        // ----------------------------------------
        // 非同期処理（Async/Await）
        // Task { } 内で await が使える
        // ----------------------------------------
        Task {
            do {
                // ----------------------------------------
                // URLSession.shared.data(for:) は async/await 対応のメソッド
                // レスポンスデータとレスポンスヘッダが返ってくる
                // ----------------------------------------
                let (_, response) = try await URLSession.shared.data(for: req) // ここがthrowする可能性がある, UIが固まってしまう可能性を加味して async/await

                // ----------------------------------------
                // HTTPレスポンスのステータスコードを確認
                // force-cast はここでは問題ない（APIは必ずHTTP）
                // URLResponse は HTTPURLResponse 親クラスであるので、ダウンキャストするしかない
                // ----------------------------------------
                let http = response as! HTTPURLResponse // "!"はもし違えばエラーになる

                // ----------------------------------------
                // UI更新は必ずメインスレッド（MainActor）
                // loginSuccess や errorMessage を更新すると View に反映される
                // ----------------------------------------
                await MainActor.run {
                    if http.statusCode == 200 {
                        // 200ならログイン成功と判定し、画面遷移トリガーを立てる
                        self.loginSuccess = true
                    } else {
                        // 200以外は失敗
                        self.errorMessage = "ログイン失敗"
                    }
                }

            } catch {
                // ----------------------------------------
                // 通信できなかった場合（ネットワーク不通など）
                // ここもUI更新なので MainActor で行う
                // ----------------------------------------
                await MainActor.run {
                    self.errorMessage = "通信エラー"
                }
            }
        }
    }
}
