//
//  Extensions.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

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


extension UITableView {
    //MARK: - Cell
    func registerNibWithCell<T: UITableViewCell>(_ cell: T.Type) {
        register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: String(describing: cell))
    }
    
    func registerClassWithCell<T: UITableViewCell>(_ cell: T.Type) {
        register(cell, forCellReuseIdentifier: String(describing: cell))
    }
    
    func dequeueCell<T: UITableViewCell>(_ cell: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: cell)) as! T
    }
    
    func dequeueCell<T: UITableViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: cell), for: indexPath) as! T
    }
    
    //MARK: - HeaderFooterView
    func registerNibWithHeaderFooterView<T: UITableViewHeaderFooterView>(_ headerFooterView: T.Type) {
        register(UINib(nibName: String(describing: headerFooterView), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: headerFooterView))
    }
    
    func registerClassWithHeaderFooterView<T: UITableViewHeaderFooterView>(_ headerFooterView: T.Type) {
        register(headerFooterView, forHeaderFooterViewReuseIdentifier: String(describing: headerFooterView))
    }
    
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(_ headerFooterView: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: headerFooterView)) as! T
    }
}
