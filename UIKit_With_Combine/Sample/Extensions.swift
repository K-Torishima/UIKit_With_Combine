//
//  Extensions.swift
//  UIKit_With_Combine
//
//  Created by 鳥嶋 晃次 on 2021/09/24.
//

import UIKit
import Combine
import CombineCocoa

extension UITextField {
    // 元々CombineCocoaにはtextPublisherがある
    // textPublisherはテキストが変更されるたびに通知されるPublisher
    // 以下はtextFieldのフォーカスが移動してテキストが確定した時だけテキストを通知するPublisher
    // CombineCocoaはないものは作れる
    var editedTextPublisher: AnyPublisher<String?, Never> {
        controlEventPublisher(for: .editingDidEnd)
            .map { [weak self] in
                self?.text
            }
            .eraseToAnyPublisher()
    }
}
