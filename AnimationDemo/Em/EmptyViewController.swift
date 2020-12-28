//
//  EmptyViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/24.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {
    fileprivate lazy var coverView: IFBatchShareFirstEnterView = {
        let cover = IFBatchShareFirstEnterView()
        return cover
    }()
    fileprivate lazy var exceptionView: IFExceptionView = {
        let emptyView = IFExceptionView()
        return emptyView
    }()
    fileprivate lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    fileprivate lazy var wechatImg: IFMyShareWechatView = {
        let wechatImg = IFMyShareWechatView()
        return wechatImg
    }()
    
    fileprivate var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(coverView)
        coverView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

/**
 # Swift面向协议
 ## 利用协议实现前缀效果
    - 1. 定义一个结构体``Lee<Base>``，用于生成计算属性
        ```Swift
         struct Lee<Base> {
             let base: Base
             
             init(_ base: Base) {
                 self.base = base
             }
         }
        ```
    - 2. 定义一个协议 ``LeeCompatible``
        ```Swift
        protocol LeeCompatible { }
        ```
    - 3. 给协议 ``LeeCompatible``扩展Lee<Base>计算属性 `` var lee: Lee<Self> ``
        ```Swift
         extension LeeCompatible {
             var lee: Lee<Self> {
                 get { Lee(self) }
                 set {}
             }
             static var lee: Lee<Self>.Type {
                 get { Lee<Self>.self }
                 set { }
             }
         }
        ```
    - 4. 给某一个具体的类型（String）使用该协议
        ```Swift
        extension String: LeeCompatible { }
        ```
    - 5.给定义的指定Lee<Base>中的Base具体类型，同时扩展该类具体要使用的方法或计算属性
    ```Swift
         extension Lee where Base == String {
             var numberCount: Int {
                 var count = 0
                 let strs = ("0"..."9")
                 for c in base where strs.contains(String(c)) {
                     count += 1
                 }
                 return count
             }
         }
    ```
    - 6.使用定义好的前缀
    ```Swift
         func testLee() {
            let count = "asdf123".lee.numberCount
         }
    ```
    - 优点：可以在给类型扩展属性和方法时，多本类的方法不会干扰，或者名称重合，比如在在String中有一个numberCount的计算属性，通过该方式来给String扩展一个numberCount的计算属性，不会对String本类中的numberCount的产生影响
 ```Swift
     struct Lee<Base> {
         let base: Base
         
         init(_ base: Base) {
             self.base = base
         }
     }

     protocol LeeCompatible { }

     extension LeeCompatible {
         var lee: Lee<Self> {
             get { Lee(self) }
             set {}
         }
         static var lee: Lee<Self>.Type {
             get { Lee<Self>.self }
             set { }
         }
     }

     extension String: LeeCompatible { }

     extension Lee where Base == String {
         var numberCount: Int {
             var count = 0
             let strs = ("0"..."9")
             for c in base where strs.contains(String(c)) {
                 count += 1
             }
             return count
         }
     }

     extension Lee where Base: ExpressibleByStringLiteral {
         var numberCount: Int {
             var count = 0
             let strs = ("0"..."9")
             for c in (base as! String) where strs.contains(String(c)) {
                 count += 1
             }
             return count
         }
     }

     func testLee() {
        let count = "asdf123".lee.numberCount
         print(count)
         LeePerson.lee.test()
         LeeStudent.lee.test()
         
         let p = LeePerson()
         p.lee.run()
         
         let s = LeeStudent()
         s.lee.run()
     }

     class LeePerson { }
     class LeeStudent: LeePerson {}
     extension LeePerson: LeeCompatible { }

     extension Lee where Base: LeePerson {
         func run() {}
         static func test() {}
     }
 ```
 ## 利用协议实现类型判断
     ```Swift
     protocol ArrayType { }
     extension Array: ArrayType { }
     extension NSArray: ArrayType { }

     func isArrayType(_ type: Any.Type) -> Bool {
         return type is ArrayType.Type
     }
     isArrayType([Int].self)
     isArrayType([Any].self)
     isArrayType(NSArray.self)
     isArrayType(NSMutableArray.self)
     ```
 */




struct KF<Base> {
    let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
}

protocol KFCompatiable { }

extension KFCompatiable {
    var kf: KF<Self> {
        get { KF(self) }
        set { }
    }
}

extension UIImageView: KFCompatiable { }

extension KF where Base: UIImageView {
    
    func setURL(_ str: URL) {
        
    }
}

func testImageKF() {
    let imgView = UIImageView()
    imgView.kf.setURL(URL(string: "")!)
}
