//
//  LoginModel.swift
//  UIKit_With_Combine
//
//  Created by 鳥嶋 晃次 on 2021/09/24.
//

import Combine

final class LoginModel {
    private(set) var userId = ""
    private(set) var password = ""
    @Published private(set) var isValid = false
    
    func update(userId: String, password: String) {
        self.userId = userId
        self.password = password
    
        // isValidの条件
        isValid = userId.count >= 4 && password.count >= 4
    }
    
    func login() {
        // ここでIdとPassが渡されてLoginするみたいな実装ができる
        // 今回はPrintのみ
        print("userId: \(userId), password: \(password)")
    }
}
