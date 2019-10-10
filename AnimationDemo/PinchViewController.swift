//
//  PinchViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/9.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class PinchViewController: UIViewController {
    @IBOutlet weak var startX: UITextField!
    @IBOutlet weak var endY: UITextField!
    @IBOutlet weak var endX: UITextField!
    @IBOutlet weak var startY: UITextField!
    @IBOutlet weak var pointCunt: UITextField!
    @IBOutlet weak var animationView: UIView!
    
    @IBAction func enterAction(_ sender: Any) {
        guard let startXStr = startX.text,
        let startYStr = startY.text,
        let endXStr = endX.text,
        let endYStr = endY.text,
        let countStr = pointCunt.text else {
            return
        }
        guard let startPointX = Float(startXStr),
        let startPointY = Float(startYStr),
        let endPointX = Float(endXStr),
        let endPointY = Float(endYStr),
        let count = Int(countStr) else {
            return
        }
        let startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
        let endPoint = CGPoint(x: CGFloat(endPointX), y: CGFloat(endPointY))
        let points = startPoint.randomPoinits(endPoint: endPoint, pointCount: count)
        IFPinchAnimation.showKeyframe(in: animationView.layer,
                                      centerPoint: animationView.center,
                                      points: points)
    }
    
    var animationName: String?

    
}


extension CGPoint {
    
    func symmetricPoint(with centerPoint: CGPoint) -> CGPoint {
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
    
    func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.isEmpty {
                numbers = min < max ? Array(min ... max) : Array(max ... min)
            }
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.remove(at: index)
        }
    }
    
}
