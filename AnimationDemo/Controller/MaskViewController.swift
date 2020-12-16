//
//  MaskViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/11/19.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class MaskViewController: UIViewController {
    fileprivate lazy var lightView: FxLightView = {
        let lightView = FxLightView()
        return lightView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(lightView)
        lightView.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.size.equalTo(CGSize(width: 100, height: 100))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lightView.startPathAnimation()
    }
    
    func testMask() {
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


class FxLightView: UIView {
    fileprivate lazy var shadowView: FXShadowView = {
        let shadowView = FXShadowView()
        shadowView.shadowOffset = .zero
        shadowView.shadowColor = UIColor.red.cgColor
        shadowView.shadowRadius = 5
        shadowView.shadowOpacity = 1
        shadowView.cornerRadius = 4
        return shadowView
    }()
    fileprivate lazy var shapeView: FXShapeView = {
        let shapeView = FXShapeView()
        (shapeView.layer as? CAShapeLayer)?.fillColor = UIColor.clear.cgColor
        (shapeView.layer as? CAShapeLayer)?.strokeColor = UIColor.black.cgColor
        (shapeView.layer as? CAShapeLayer)?.lineWidth = 2
        return shapeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(shadowView)
        shadowView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeView.frame = bounds
        shadowView.layer.mask = shapeView.layer
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
        (shapeView.layer as? CAShapeLayer)?.path = path
        (shapeView.layer as? CAShapeLayer)?.strokeEnd = 1.0
        (shapeView.layer as? CAShapeLayer)?.strokeStart = 0.9
    }
    
    func startPathAnimation() {
        let group = CAAnimationGroup()
        group.fillMode = .forwards
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        group.isRemovedOnCompletion = false
        group.duration = 1
        group.setValue("strokeEndFirst", forKey: "name")
        group.delegate = self
        let strokeEnd =  CAKeyframeAnimation(keyPath: "strokeEnd")
        
        strokeEnd.values = [1, 0.1]
        
        let strokeStart = CAKeyframeAnimation(keyPath: "strokeStart")
        strokeStart.values = [0.9, 0]
        
        group.animations = [strokeEnd, strokeStart]
        shapeView.layer.add(group, forKey: nil)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension FxLightView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as?  String else {
            return
        }
        if name == "strokeEndFirst" {
            let group = CAAnimationGroup()
            group.fillMode = .forwards
            group.timingFunction = CAMediaTimingFunction(name: .linear)
            group.isRemovedOnCompletion = false
            group.duration = 0.25
            group.delegate = self
            group.setValue("strokeEndSecond", forKey: "name")
            let strokeEnd =  CAKeyframeAnimation(keyPath: "strokeEnd")
            strokeEnd.values = [0.1, 0]
            group.animations = [strokeEnd]
            shapeView.layer.add(group, forKey: nil)
        }
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

