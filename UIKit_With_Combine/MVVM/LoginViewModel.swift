//
//  LoginViewModel.swift
//  UIKit_With_Combine
//
//  Created by 鳥嶋 晃次 on 2021/09/24.
//

import Foundation
import Combine
import UIKit.UIColor

final class LoginViewModel {
    private var subscriptions = Set<AnyCancellable>()
    private let model = LoginModel()
    
    let userId = CurrentValueSubject<String?, Never>(nil)
    let password = CurrentValueSubject<String?, Never>(nil)
    
    let loginButtonTap = PassthroughSubject<Void, Never>()
    let loginButtonIsEnabled: AnyPublisher<Bool, Never>
    let loginButtonIsEnabledColor: AnyPublisher<UIColor?, Never>
    let validLabelText: AnyPublisher<String?, Never>
    
    init() {
        loginButtonIsEnabled = model.$isValid
            .map { $0 }
            .eraseToAnyPublisher()
        
        loginButtonIsEnabledColor = model.$isValid
            .map { isValid in
                isValid ? .red : .lightGray
            }
            .eraseToAnyPublisher()
        
        validLabelText = model.$isValid
            .map { isValid in
                isValid ? "Valid" : "Invalid"
            }
            .eraseToAnyPublisher()
        
        userId.compactMap { $0 }
            .combineLatest(password.compactMap { $0 })
            .sink { userId, password in
                self.model.update(userId: userId, password: password)
            }
            .store(in: &subscriptions)
        
        loginButtonTap
            .sink {
                self.model.login()
            }
            .store(in: &subscriptions)
                    
    }
}
