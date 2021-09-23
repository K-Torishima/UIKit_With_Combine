//
//  LoginViewController.swift
//  UIKit_With_Combine
//
//  Created by 鳥嶋 晃次 on 2021/09/24.
//

/*
 ## 画面
 - ユーザ ID を入力するテキストフィールド
 - パスワードを入力するテキストフィールド
 - ログインを実行するボタン
 - ユーザ ID とパスワードの入力文字数が適切か表示するラベル
 
 ## 動作仕様
 
 - ユーザ ID とパスワードがそれぞれ 4 文字以上あるとき、ラベルに "Valid" と表示する。そうでないとき、ラベルに "Invalid" と表示する。
 - Valid の場合だけ、ログインボタンを有効にする。そうでないとき、ログインボタンは無効にする。
 - ログインボタンが連打されたとき、ログイン処理が連続で何度も実行されないようにする。
 
 UIの実装を見るのが目的のためその後の処理は実際に行わない
 
 役割
 - LoginModel
   ユーザーIDとパスワードの条件判定及びログイン処理を行う
 - LoginViewModel
 　Modelの変更を加工しViewにBindする
 - LoginViewContoroller(Storyboard)
 　ViewModelからBindされたものを表示する
 
 */

import UIKit
import Combine
import CombineCocoa
 
final class LoginViewController: UIViewController {
    private var subscriptons = Set<AnyCancellable>()
    private let viewModel = LoginViewModel()
    
    @IBOutlet private weak var userIdTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var validLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdTextField.textPublisher
            .sink(receiveValue: viewModel.userId.send)
            .store(in: &subscriptons)
        
        passwordTextField.textPublisher
            .sink(receiveValue: viewModel.password.send)
            .store(in: &subscriptons)
        
        loginButton.tapPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveValue: viewModel.loginButtonTap.send)
            .store(in: &subscriptons)
        
        viewModel.loginButtonIsEnabled
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &subscriptons)
        
        viewModel.loginButtonIsEnabledColor
            .assign(to: \.backgroundColor, on: loginButton)
            .store(in: &subscriptons)
                
        viewModel.validLabelText
            .assign(to: \.text, on: validLabel)
            .store(in: &subscriptons)
    }
}
