//
//  MultiLanguageAlert.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/21.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation

/**
 键盘语言类型，
 键盘文本，
 输入框文本内容，
 textPlaceholder，
 输入字符长度
 */
struct TextInputModel {
    var keyboardType: Int = 0
    var keyboardDesc: String?
    var inputContent: String?
    var textPlaceholder: String?
    var textInputLength: Int = 200
    var isSelect: Bool = false
    
}

extension TextInputModel: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var str = "\n"
        let properties = Mirror(reflecting: self).children
        for child in properties {
            if let name = child.label {
                str += name + ": \(child.value)\n"
            }
        }
        return str
    }
}

