//
//  ViewController.swift
//  UIKit_With_Combine
//
//  Created by 鳥嶋 晃次 on 2021/09/24.
//

import UIKit
import Combine
// RxCocoaみたいなもの
// 使う必要はない
import CombineCocoa

final class ViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe_button()
        subscribe_textField()
    }
    
    func subscribe_button() {
        // 使うだけならこれ
        button.tapPublisher
            .sink { _ in
                print("button tap")
            }
            .store(in: &subscriptions)
        
        // debounce
        /*
         ボタンが連打で押された場合上のコードだとイベントが連打で発生する
         よって何度も同じクロージャが呼ばれる
         実装要件で何度も呼ばれてはいけない場合がある時はdebouceを使って調節できる
         連打された時は一度だけイベントが発生するようにできる
         カウンターとかなら特に必要なさそう
         というかその程度のアプリならCombineすらいらないと思うが
         
         
         debounce
         イベントの流量を調節するOperator
         イベント発生から一定時間以内に次のイベントが発生した場合そのイベントはpublishせずに捨てる
         今回が0.5秒を設定しているため0.5秒以内にタップされなければタップイベントはpublishされる
         0.5秒以内にタップされた場合はpublishされず捨てられる
         よって、最後のタップイベントだけが発生されることになる
         */
        
        button.tapPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { _ in
                print("＊debounce Operated＊")
            }
            .store(in: &subscriptions)
    }
    
    func subscribe_textField() {
        textField.textPublisher
            .sink { text in
                print(text ?? "")
            }
            .store(in: &subscriptions)
        
        // textField.editedTextPublisher
        //     .sink { text in
        //         print(text ?? "")
        //     }
        //     .store(in: &subscriptions)
    }
}
