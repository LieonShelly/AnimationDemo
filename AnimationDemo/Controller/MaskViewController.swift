//
//  MaskViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/11/19.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class MaskViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         # mask的用法
            - mask是遮罩，它会挡住父视图的渲染
            - 父视图渲染部分是mask不透明的像素点; mask透明部分，父视图部分就会不显示
         */
        let frame = CGRect(x: 0, y: 0, width: 300, height: 500)
        let blueView = UIView(frame: frame)
        blueView.backgroundColor = .blue

        let redView = UIImageView(frame: frame)
        redView.image = UIImage(named: "girl")

        let mask = UIImageView(frame: frame)
        mask.contentMode = .scaleAspectFit
        mask.image =  UIImage(named: "light")
        redView.mask = mask

        blueView.addSubview(redView)
        view.backgroundColor = .white
        view.addSubview(blueView)
    }
    
}


/**
 使用 Property Wrapper 为 Codable 解码设定默认值
 
 # 这样做的优点
    - 不用为每个类去重写 init(from:) 方法去设置默认值，减少了大量了每个类型添加这么一坨 CodingKeys 和 init(from:)方法，减少重复工作
 */

protocol DefaultValue {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

@propertyWrapper
struct Default<T: DefaultValue> {
    var wrappedValue: T.Value
}

extension Default: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
}

extension KeyedDecodingContainer {
    func decode<T>( _ type: Default<T>.Type, forKey key: Key) throws -> Default<T> where T: DefaultValue {
        try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
    }
}

struct Video: Decodable {
    enum State: String, Decodable, DefaultValue {
        case streaming
        case archived
        case unknown
        
        static let defaultValue = Video.State.unknown
    }
    let id: Int
    let title: String
    @Default<State> var state: State
    @Default.False var commentEnabled: Bool
    @Default.True var publicVideo: Bool
}


extension Bool {
    enum False: DefaultValue {
        static let defaultValue = false
    }
    enum True: DefaultValue {
        static let defaultValue = true
    }
}


extension Default {
    typealias True = Default<Bool.True>
    typealias False = Default<Bool.False>
}

let json = #"{"id": 12345, "title": "My First Video", "state": "reserved"}"#
let value = try! JSONDecoder().decode(Video.self, from: json.data(using: .utf8)!)

