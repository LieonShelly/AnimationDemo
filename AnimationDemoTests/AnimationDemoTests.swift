//
//  AnimationDemoTests.swift
//  AnimationDemoTests
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import XCTest
@testable import AnimationDemo

class AnimationDemoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSymmetricPoint() {
        let startPoint = CGPoint(x: 300, y: 500)
        let centerPoint = CGPoint(x: UIScreen.main.bounds.width * 0.5,
                                  y: UIScreen.main.bounds.height * 0.5)
        let endPoint = startPoint.symmetricPoint(with: centerPoint )
        XCTAssert(endPoint.x == 2 * centerPoint.x - startPoint.x)
        XCTAssert(endPoint.y == 2 * centerPoint.y - startPoint.y)
        debugPrint("centerPoint:\(centerPoint) - endPoint:\(endPoint)")
    }
    
    func testRandomPoints() {
        let startPoint = CGPoint(x: 30, y: 80)
        let endPoint = CGPoint(x: 300, y: 800)
        let points = startPoint.randomPoinits(endPoint: endPoint, pointCount: 100)
        debugPrint("points:\(points)")
    }
    
    func testInsetBy() {
        let frame = CGRect(x: 30, y: 70, width: 80, height: 100)
        let newFrame = frame.inset(by: UIEdgeInsets(top: 10,
                                                    left: 20,
                                                    bottom: 30,
                                                    right: 40))
        debugPrint("newFrame:\(newFrame) - frame:\(frame)")
    }

}



extension CGPoint {
    
    func symmetricPoint(with centerPoint: CGPoint) -> CGPoint {
        /// 任意一点（x, y）关于（a, b）的对称点为 （2a-x, 2b-y）
        return CGPoint(x: 2 * centerPoint.x - x, y: 2 * centerPoint.y - y)
    }

    func randomPoinits(endPoint: CGPoint, pointCount: Int) -> [CGPoint] {
           let startPointX = x
           let startPointY = y
           let endPointX = endPoint.x
           let endPointY = endPoint.y
           let generatorX =  randomSequenceGenerator(min: Int(startPointX), max: Int(endPointX))
           let generatorY =  randomSequenceGenerator(min: Int(startPointY), max: Int(endPointY))
           let randomX = (0..<pointCount).map {_ in generatorX() }
           let randomY = (0..<pointCount).map {_ in generatorY() }
           let points = zip(randomX, randomY).map { CGPoint(x: CGFloat($0.0), y: CGFloat($0.1))}
           return points
       }
       
     fileprivate  func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
           var numbers: [Int] = []
           return {
               if numbers.isEmpty {
                   numbers = Array(min ... max)
               }

               let index = Int(arc4random_uniform(UInt32(numbers.count)))
               return numbers.remove(at: index)
           }
       }
       
}

