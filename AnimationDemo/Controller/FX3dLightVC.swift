//
//  FX3dLightVC.swift
//  AnimationDemo
//
//  Created by lieon on 2020/8/29.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import Zip

class FX3dLightVC: UIViewController {

    fileprivate lazy var sourceBtn: FX3DLightExchangeLightSourceBtn = {
        let sourceBtn = FX3DLightExchangeLightSourceBtn()
        return sourceBtn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(sourceBtn)
        sourceBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(FX3DLightExchangeLightSourceBtn.UISize.size)
        }
    }
    
}

class ContrastCellFuck: UICollectionViewCell {
    lazy var contrastView : FXTutorialImageContrastView = {
        let contrastView = FXTutorialImageContrastView()
        return contrastView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
        contentView.addSubview(contrastView)
        contrastView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

struct ContrastUIData {
    var originImage: UIImage
    var effectImage: UIImage
}


protocol TrafficLightOption {
    associatedtype Value
    
    static var defaultValue: Value { get }
}

class TrafficLight {
    enum State {
        case stop
        case proceed
        case caution
    }
    private var options = [ObjectIdentifier: Any]()

    subscript<T: TrafficLightOption>(option type: T.Type) -> T.Value {
        get {
            options[ObjectIdentifier(type)] as? T.Value ?? type.defaultValue
        }
        set {
            options[ObjectIdentifier(type)] = newValue
        }
    }
    
    private(set) var state: State = .stop {
        didSet{ onStateChanged?(state) }
    }
    var onStateChanged: ((State) -> Void)?
    var stopDuration = 4.0
    var proceedDuration = 6.0
    var cautionDuration = 1.5
    private var timer: Timer?
    
    private func turnState(_ state: State) {
        switch state {
        case .proceed:
            timer = Timer.scheduledTimer(withTimeInterval: proceedDuration, repeats: false) { _ in
                self.turnState(.caution)
            }
        case .caution:
            timer = Timer.scheduledTimer(withTimeInterval: cautionDuration, repeats: false) { _ in
                self.turnState(.stop)
            }
        case .stop:
            timer = Timer.scheduledTimer(withTimeInterval: stopDuration, repeats: false) { _ in
                self.turnState(.proceed)
            }
        }
        self.state = state
    }
    
    func start() {
        guard timer == nil else { return }
        turnState(.stop)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}

extension TrafficLight {
    enum GreenLightColor: TrafficLightOption {
        case green
        case turquoise
        
        static var defaultValue: GreenLightColor = .green
    }
}

extension TrafficLight {
    var preferredGreenLightColor: TrafficLight.GreenLightColor {
        get { self[option: GreenLightColor.self] }
        set { self[option: GreenLightColor.self] = newValue}
    }
}

extension TrafficLight.GreenLightColor {
    var color: UIColor {
        switch self {
        case .green:
            return .green
        case .turquoise:
            return UIColor(red: 0.25, green: 0.88, blue: 0.82, alpha: 1.00)
        }
    }
}

/**
 Option Pattern: 在不添加存储属性的前提下，提供了一种向已有类型中以类型安全的方式添加“存储”的手段。
 
 # 使用步骤
 - 0.为model定一个一个option接口 modelOption
    ```swift
     protocol PersonOption {
         associatedtype Value
         static var defaultValue: Value { get }
     }
    ```
 - 1.定义一个泛用的 options 字典，来将需要的选项值放到里面。加入 options 属性和下标方法
    ```swift
    private var option: [ObjectIdentifier: Any] = [ObjectIdentifier: Any]()
 
    /// option的下标方法
    subscript<T: PersonOption>(option type: T.Type) -> T.Value {
         get { option[ObjectIdentifier(type)] as? T.Value ?? T.defaultValue }
         set { option[ObjectIdentifier(type)] = newValue }
     }
    ```
 - 2. 为需要扩展的存储属性的类型，遵守modelOption
    ```swift
     enum Color: PersonOption {
         case red
         case blue
         
         static var defaultValue: Color = .red
     }
     
     extension Int: PersonOption {
         static var defaultValue: Int = 0
     }
    ```
 - 在model的extension中拓展需要的'存储' 属性
    ```swift
     extension Person {
         var color: Color {
             get { self[option: Color.self] }
             set { self[option: Color.self] = newValue }
         }
         
         var height: Int {
             get { self[option: Int.self] }
             set { self[option: Int.self] = newValue }
         }
    }
    ```
 
 # 优点
 - 节约内存开销
 - 易于扩展，在extension中添加 ‘存储属性’，在不修改他人源码的情况下，为其扩展接口
 
 # demo
 - 文中相关的代码可以在[这里找到](https://gist.github.com/LieonShelly/837b8352c602250150a898aaae676340)。

 */

class Person {
    enum Color: PersonOption {
        case red
        case blue
        
        static var defaultValue: Color = .red
    }
    var age = 0
    
    private var option: [ObjectIdentifier: Any] = [ObjectIdentifier: Any]()
 
    subscript<T: PersonOption>(option type: T.Type) -> T.Value {
        get { option[ObjectIdentifier(type)] as? T.Value ?? T.defaultValue }
        set { option[ObjectIdentifier(type)] = newValue }
    }
}


extension Int: PersonOption {
    static var defaultValue: Int = 0
}

extension Person {
    var color: Color {
        get { self[option: Color.self] }
        set { self[option: Color.self] = newValue }
    }
    
    var height: Int {
        get { self[option: Int.self] }
        set { self[option: Int.self] = newValue }
    }
}

protocol PersonOption {
    associatedtype Value
    static var defaultValue: Value { get }
}

extension Person.Color {
    var uiColor: UIColor {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        }
    }
}
/**
 # 枚举
 ## 枚举的基本用法
 
 ```swift
 enum Direction {
     case north
     case south
     case east
     case west
 }
 let dir: Direction = .north
 ```
 ## 关联值(Associated Values)
 ```swift
 enum Score {
     case points(Int)
     case grade(String)
 }

 let score: Score = .points(3)

 ```
 
 ## 原始值(Raw Values)
 - 枚举成员可以使用相同类型的默认值预先对应，这个默认值叫做：原始值
 - 原始值不占用枚举变量的内存
 
 ```swift
 enum Grade: String {
     case perfect = "A"
     case great = "B"
     case good = "C"
     case bad = "D"
 }
 ```
 
 ## 隐式原始值(Implicitly Assigned Raw Values)
 - 如果枚举的原始值类型是Int，String，Swift会自动分配原始值
 ```
 enum Direction: String {
     case north = "north"
     case south = "south"
     case east = "east"
     case west = "west"
 }
 
 /// 等价于
 enum Direction {
     case north
     case south
     case east
     case west
 }
 ```
 
 ## 递归枚举（Recursive Enumeration）
 
 ```Swift
 indirect enum ArithExpr {
     case number(Int)
     case sum(ArithExpr, ArithExpr)
 }
 enum ArithExpr {
     case number(Int)
     indirect case sum(ArithExpr, ArithExpr)
 }
 
 ```
 
 # MemoryLayout
 - MemoryLayout可以获取到数据类型占用的内存大小
 
 ## 基础枚举内存大小为
    - 系统分配1个字节
    - 实际用到1个字节
    - 按1个字节对接
 
 ```swift

 enum TestEnum1 {
     case test1
     case test2
     case test3
 }

 enum TestEnum2: Int {
     case test1
     case test2
     case test3
 }
 
 var test = TestEnum1.test3
 print(Mems.ptr(ofVal: &test))
 print(Mems.size(ofVal: &test))
 let stride = MemoryLayout<TestEnum1>.stride // 1
 let size = MemoryLayout<TestEnum1>.size // 1
 let alignment = MemoryLayout<TestEnum1>.alignment // 1
 ```
 ## 关联值枚举内存大小为（TestEnum3为例）
    - 分配的内存大小为32个字节
    - 实际用到的字节为25个字节
    - 以8个字节对齐
 ```swift
 // 01 00 00 00 00 00 00 00
 // 02 00 00 00 00 00 00 00
 // 03 00 00 00 00 00 00 00
 // 01
 // 分配了32个字节，但是只用到25个字节，前24个字节用来存储关联值，第25个字节用来存储成员值
 var test = TestEnum3.test2(1, 2, 3)
 // 01 00 00 00 00 00 00 00
 // 02 00 00 00 00 00 00 00
 // 03 00 00 00 00 00 00 00
 // 00
 test = .test1(1, 2, 3)
 // 03 00 00 00 00 00 00 00
 // 00 00 00 00 00 00 00 00
 // 00 00 00 00 00 00 00 00
 // 02
 test = .test3(3)
 // 01 00 00 00 00 00 00 00
 // 00 00 00 00 00 00 00 00
 // 00 00 00 00 00 00 00 00
 // 03
 test = .test4(true)
 
 // 00 00 00 00 00 00 00 00
 // 00 00 00 00 00 00 00 00
 // 00 00 00 00 00 00 00 00
 // 04
 test = .test5
 
 let stride = MemoryLayout<TestEnum3>.stride // 32
 let size = MemoryLayout<TestEnum3>.size // 25
 let alignment = MemoryLayout<TestEnum3>.alignment // 8
 ```
 
 ## 总结：
 - 1个字节存储成员值
 - N个字节存储关联值(N去最大case的关联值的个数)，任何一个case的关联值共用这N个字节
 - 只有1个case的无关联值枚举内存为0
 - 单个case的关联值枚举内存关联值的内存大小 (因为就一个case，不需要存储值来区分)
 - 原始值不占用内存大小（为什么？因为可以这样写）
    ```swift
     var rawValue: Int {
         switch self {
         case .test1:
             return 0
         case .test2:
             return 0
         case .test3:
             return 0
         case .test4:
             return 0
         case .test5:
             return 0
         }
     }
    ```
 */

enum Password {
    case number(Int, Int, Int, Int)
    case other
}

func testEnum() {
    // 01 00 00 00 00 00 00 00
    // 02 00 00 00 00 00 00 00
    // 03 00 00 00 00 00 00 00
    // 01
    // 分配了32个字节，但是只用到25个字节，前24个字节用来存储关联值，第25个字节用来存储成员值
    var test = TestEnum3.test2(1, 2, 3)
    // 01 00 00 00 00 00 00 00
    // 02 00 00 00 00 00 00 00
    // 03 00 00 00 00 00 00 00
    // 00
    test = .test1(1, 2, 3)
    // 03 00 00 00 00 00 00 00
    // 00 00 00 00 00 00 00 00
    // 00 00 00 00 00 00 00 00
    // 02
    test = .test3(3)
    // 01 00 00 00 00 00 00 00
    // 00 00 00 00 00 00 00 00
    // 00 00 00 00 00 00 00 00
    // 03
    test = .test4(true)
    
    // 00 00 00 00 00 00 00 00
    // 00 00 00 00 00 00 00 00
    // 00 00 00 00 00 00 00 00
    // 04
    test = .test5
    
    print(Mems.ptr(ofVal: &test))
    let stride = MemoryLayout<TestEnum3>.stride // 1
    let size = MemoryLayout<TestEnum3>.size // 1
    let alignment = MemoryLayout<TestEnum3>.alignment // 1
    print("stride: \(stride) - size: \(size) - alignment: \(alignment) ")
}

enum TestEnum1 {
    case test1
    case test2
    case test3
}

enum TestEnum2: Int {
    case test1
    case test2
    case test3
}

enum TestEnum3 {
    case test1(Float, Int, Int)
    case test2(Int, Int, Int)
    case test3(Int)
    case test4(Bool)
    case test5
}

/**
# 下标（subscript）
 - 使用subscript可以给任意类型（枚举、结构体、类）增加下标功能
 - subscript的语法类似于实例方法、计算属性，本质就是方法（函数）
 - n subscript可以没有set方法，但必须要有get方法
 - 可以设置参数标签
 - 下标可以是类型方法
 ```Swift
 class Point {
     var x = 0.0, y = 0.0
     
     subscript(index: Int) -> Double {
         set {
             if index == 0 {
                 x = newValue
             } else if index == 1 {
                 y = newValue
             }
         }
         get {
             if index == 0 {
                 return x
             } else if index == 1 {
                 return y
             }
             return 0
         }
     }
 }

 var point = Point()
 point[0] = 11
 point[1] = 23
 ```
 */



