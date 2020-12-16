//
//  AppDelegate.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: FXWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = FXWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
        window?.makeKeyAndVisible()
        test()
        return true
    }
    
}

func test(_ num: inout Int) {
    num = 20
}


struct Circle {
    var radius: Float = 0
    var diametter: Float {
        set {
            radius = newValue * 0.5
        }
        get {
            return radius * 2
        }
    }
}


protocol Circleable {
    var radius: Float { get set }
    var diameter: Float { get set }
}

extension Circleable {
    var radius: Float { 10 }
    var diameter: Float { 20 }
}

struct TestCycle: Circleable {
    var radius: Float
    var diameter: Float
    
}

func test() {
    
    /**
     # 对象的内存布局：
        - 第-个8个字节存储类相关的信息表的地址，
        - 存储引用计数相关的信息表的地址
        - 后面开始存储实例属性的内存大小
     # Swift中多态的实现方式
        - 底层实现与C++中的多态一致，采用的是虚表
        - 根据在类信息地址找到虚表的首地址，虚表中存了类信息和函数的入口地址
     
     ```Swift
     class Animal {
         var age = 12
         var num = 23
         
         func sepak() {
             print("Animal-Speak")
         }
         
         func eat() {
             print("Animal-eat")
         }
     }
     
     class Dog: Animal {
         var weight: Int = 0
         
         override func sepak() {
             print("Dog-sepak")
         }
         
         override func eat() {
             print("Dog-eat")
         }
     }
     
     class ErHa: Dog {
         var iq: Int = 0
         
     }
     
     // 0x600001257bc0
     /**
      A8 91 FB 01 01 00 00 00
      03 00 00 00 00 00 00 00
      0F 00 00 00 00 00 00 00
      17 00 00 00 00 00 00 00
      */
     let ani = Animal()
     ani.age = 15
     ani.sepak()
     
     // 0x600001285800
     /*
      88 92 FB 01 01 00 00 00
      03 00 00 00 00 00 00 00
      0A 00 00 00 00 00 00 00
      17 00 00 00 00 00 00 00
      14 00 00 00 00 00 00 00
      */
     let dog = Dog()
     dog.age = 10
     dog.weight = 20
     
     // 0x600001285950
     /**
      88 F3 AD 0E 01 00 00 00
      03 00 00 00 00 00 00 00
      0A 00 00 00 00 00 00 00
      17 00 00 00 00 00 00 00
      14 00 00 00 00 00 00 00
      1E 00 00 00 00 00 00 00
      */
     let erHa = ErHa()
     erHa.age = 10
     erHa.weight = 20
     erHa.iq = 30
     ```
     */
    
}

/**
#Any,AnyObject
 - Any：可以代表任意类型（枚举，结构体，类，函数类型）
 - AnyObject：可以代表任意类类型
 # X.self, X.Type, AnyClass
 - X.self是一个元类型（metadata）的指针，metadata存放着类型相关的信息
 - X.self属于X.Type类型
 ```Swift
 class Person {
     
 }

 class Student: Person {
 }

 let perType: Person.Type = Person.self
 let stuType: Student.Type = Student.self
 let anyType: AnyObject.Type = Person.self
 ```
 # Self
 - 代表当前类型
 - 一般用作返回值类型，限定返回值跟方法调用者必须是同一类型
 ```swift
 protocol Runable {
     func test() -> Self
 }

 class Doggie: Runable {
     required init() { }
     
     func test() -> Self {
         return type(of: self).init()
     }
 }

 class BigDog: Doggie { }

 var d = Doggie()
 print(d.test())

 var bd = BigDog()
 print(bd.test())

 ```
 */

