//
//  MaskViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/11/19.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MaskViewController: UIViewController {
    fileprivate let bag = DisposeBag()
    fileprivate lazy var lightView: FxLightView = {
        let lightView = FxLightView()
        return lightView
    }()
    fileprivate lazy var service: IFUploadPhotoService = IFUploadPhotoService()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        let startBtn = UIButton(type: .infoDark)
        let stopBtn = UIButton(type: .infoDark)
        let stack = UIStackView(arrangedSubviews: [startBtn, stopBtn])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        startBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.service.upload()
            })
            .disposed(by: bag)
        stopBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.service.stopUpload()
            })
            .disposed(by: bag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        service.stopUpload()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        service.upload()
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

/**
 # 泛型
 - 将类型参数化，类似于C++中的模板
 ```Swift
 class Stack<E> {
     var elements = [E]()
     
     func push(_ element: E) {
         elements.append(element)
     }
     
     func pop() -> E {
         return elements.removeLast()
     }
     
     func top() -> E {
         return elements.last!
     }
     
     func size() -> Int {
         return elements.count
     }
 }
 ```
 - 可以在协议中定一个泛型(关联类型)
 ```Swift
 protocol Stackable {
     associatedtype Element
     mutating func push(_ element: Element)
     mutating func pop() -> Element
     func top() -> Element
     func size() -> Int
 }

 class Stack<E>: Stackable {
     var elements = [E]()
     func push(_ element: E) {
         
     }
     mutating func pop() -> E {
         return elements.removeLast()
     }
     func top() -> E {
         return elements.last!
     }
     func size() -> Int {
         return elements.count
     }
 }

 ```
 - 用于类型约束
 ```Swift
 protocol Runable { }
 class Person { }

 func swapValue<T: Person & Runable>(_ a: inout T, _ b: inout T) {
     (a, b) = (b, a)
 }
 
 func get<T: Runable>(_ type: Int) -> T {
     if type == 0 {
         return Person() as! T
     }
     return Car() as? T
 }
}
 ```
 
 ## 不透明类型（Opaque Type）
 - 使用some关键字声明一个不透明类型
 - some限制只能返回一种类型
 ```Swift
 func get(_ type: Int) -> some Runable {
     return Car()
 }
 
 // ❌
 func get(_ type: Int) -> some Runable {
     if type == 0 {
         return Person()
     }
     return Car()
 }
 ```
 */



/**
 # 内存管理
 - Swift采用引用计数的ARC内存管理方案（堆空间）
 - Swift的ARC中有3钟引用
    - 强引用
    - 弱引用（weak reference）
     - 必须是可先类型的var，因为实例销毁后，ARC会自动弱引用设置为nil
     - ARC自动给弱引用设置nil时。不会触发属性观察器
    - 无主引用（unowned reference）
     - 不会产生强引用，实例销毁后仍然存储着实例的内存地址（类似于OC中的unsafe_unretained）
     - 在实例销毁后访问无主引用，会产生运行时错误（野指针）
 
 ## 循环引用
 - weak, unowned都能解决循环引用问题，unowned要比weak少一些性能消耗
    - 在生命周期可能会变为nil的使用weak
    - 初始化后再也不会变为nil的使用unowned
 ### 闭包的循环引用
 - 闭包表达式默认会对用到的外层对象产生额外的强引用，在闭包表达式的捕获变量声明weak或unowned引用，解决循环引用问题
 
 ### @escaping逃逸闭包
 - 逃逸闭包：闭包有可能在函数结束后调用，闭包调用逃离了函数的作用域，需要通过``@escaping``声明
 - 非逃逸闭包：闭包调用发生在函数结束前，闭包调用在函数作用域内
 
 ```Swift
// fn是非逃逸闭包
func test1(_ fn: Fn) { fn() }
// fn是逃逸闭包
var gFn: Fn?
func test2(_ fn: @escaping Fn) { gFn = fn }
// fn是逃逸闭包
func test3(_ fn: @escaping Fn) {
    DispatchQueue.global().async {
        fn()
    }
}
class Person {
    var fn: Fn
    // fn是逃逸闭包
    init(fn: @escaping Fn) {
        self.fn = fn
    }
    func run() {
        // DispatchQueue.global().async也是一个逃逸闭包
        // 它用到了实例成员（属性、方法），编译器会强制要求明确写出self
        DispatchQueue.global().async {
            self.fn()
        }
    }
}
 ```
 
- 逃逸闭包不可以捕获inout参数
 ```Swift
 typealias Fn = () -> ()
 func other1(_ fn: Fn) { fn() }
 func other2(_ fn: @escaping Fn) { fn() }
 func test(value: inout Int) -> Fn {
     other1 { value += 1 }
     // error: 逃逸闭包不能捕获inout参数
     other2 { value += 1 }
     func plus() { value += 1 }
     // error: 逃逸闭包不能捕获inout参数
     return plus
 }
 ```
 
 # 指针
 -UnsafePointer<Pointee> 类似于 const Pointee *
 UnsafeMutablePointer<Pointee> 类似于 Pointee *
 UnsafeRawPointer 类似于 const void *
 UnsafeMutableRawPointer  类似于 void *

 ```Swift
 var age = 10
 func test1(_ ptr: UnsafeMutablePointer<Int>) {
     ptr.pointee += 10
 }

 func test2(_ ptr: UnsafePointer<Int>) {
     // ptr.pointee += 10 错误
     print(ptr.pointee)
 }

 func test3(_ ptr: UnsafeMutableRawPointer) {
     ptr.storeBytes(of: 20, as: Int.self)
 }

 func test4(_ ptr: UnsafeRawPointer) {
 //    ptr.storeBytes(of: 20, as: Int.self) 错误
     print(ptr.load(as: Int.self))
 }

 ```
 ## 获得指向某个变量的指针
 ```Swift
 var age = 11
 var ptr1 = withUnsafeMutablePointer(to: &age ) { $0 }
 var ptr2 = withUnsafePointer(to: &age, { $0 })
 ptr1.pointee = 22
 print(ptr2.pointee) // 22
 print(age) // 22
 
 var ptr3 = withUnsafeMutablePointer(to: &age, { UnsafeMutableRawPointer($0) })
 var ptr4 = withUnsafePointer(to: age, { UnsafeRawPointer($0) })
 ptr3.storeBytes(of: 33, as: Int.self) // 33
 print(age) // 3
 ```
 ## 获得指向堆空实例的指针
 ```
 class Person {}
 var person = Person()
 var ptr5 = withUnsafePointer(to: &person) { UnsafeRawPointer($0) }
 var heapPtr = UnsafeRawPointer(bitPattern: ptr5.load(as: UInt.self))
 print(heapPtr)
 ```
 ## 创建指针
 ```Swift
 var ptr = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)
 ptr.storeBytes(of: 11, as: Int.self)
 ptr.advanced(by: 8).storeBytes(of: 22, as: Int.self)
 print(ptr.load(as: Int.self)) // 11
 print(ptr.advanced(by: 8).load(as: Int.self)) // 22
 ptr.deallocate()
 
 do {
     var ptr = UnsafeMutablePointer<Int>.allocate(capacity: 3)
     ptr.initialize(to: 11)
     ptr.successor().initialize(to: 22)
     ptr.successor().successor().initialize(to: 33)
     print(ptr.pointee) // 11
     print((ptr + 1).pointee) // 22
     print((ptr + 2).pointee) // 33
     print(ptr[0]) // 11
     print(ptr[1]) // 22
     print(ptr[2]) // 33
     ptr.deinitialize(count: 3)
     ptr.deallocate()
 }

 do {
     class Person {
         var age: Int
         var name: String
         init(age: Int, name: String) {
             self.age = age
             self.name = name
         }
         deinit { print(name, "deinit") }
     }
     var ptr = UnsafeMutablePointer<Person>.allocate(capacity: 3)
     ptr.initialize(to: Person(age: 10, name: "Jack"))
     (ptr + 1).initialize(to: Person(age: 11, name: "Rose"))
     (ptr + 2).initialize(to: Person(age: 12, name: "Kate"))
     // Jack deinit
     // Rose deinit
     // Kate deinit
     ptr.deinitialize(count: 3)
     ptr.deallocate()
 }
 ```
 */

func test1() {
    var age = 11
    var ptr1 = withUnsafeMutablePointer(to: &age ) { $0 }
    var ptr2 = withUnsafePointer(to: &age, { $0 })
    ptr1.pointee = 22
    print(ptr2.pointee) // 22
    print(age) // 22
    
    var ptr3 = withUnsafeMutablePointer(to: &age, { UnsafeMutableRawPointer($0) })
    var ptr4 = withUnsafePointer(to: age, { UnsafeRawPointer($0) })
    ptr3.storeBytes(of: 33, as: Int.self) // 33
    print(age) // 3
}

func test2() {
    var ptr = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)
    ptr.storeBytes(of: 11, as: Int.self)
    ptr.advanced(by: 8).storeBytes(of: 22, as: Int.self)
    print(ptr.load(as: Int.self)) // 11
    print(ptr.advanced(by: 8).load(as: Int.self)) // 22
    ptr.deallocate()
    
    do {
        var ptr = UnsafeMutablePointer<Int>.allocate(capacity: 3)
        ptr.initialize(to: 11)
        ptr.successor().initialize(to: 22)
        ptr.successor().successor().initialize(to: 33)
        print(ptr.pointee) // 11
        print((ptr + 1).pointee) // 22
        print((ptr + 2).pointee) // 33
        print(ptr[0]) // 11
        print(ptr[1]) // 22
        print(ptr[2]) // 33
        ptr.deinitialize(count: 3)
        ptr.deallocate()
    }

    do {
        class Person {
            var age: Int
            var name: String
            init(age: Int, name: String) {
                self.age = age
                self.name = name
            }
            deinit { print(name, "deinit") }
        }
        var ptr = UnsafeMutablePointer<Person>.allocate(capacity: 3)
        ptr.initialize(to: Person(age: 10, name: "Jack"))
        (ptr + 1).initialize(to: Person(age: 11, name: "Rose"))
        (ptr + 2).initialize(to: Person(age: 12, name: "Kate"))
        // Jack deinit
        // Rose deinit
        // Kate deinit
        ptr.deinitialize(count: 3)
        ptr.deallocate()
    }
}



