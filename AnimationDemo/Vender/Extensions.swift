//
//  Extensions.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

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


extension UICollectionView {
    //MARK: - Cell
    func registerNibWithCell<T: UICollectionViewCell>(_ cell: T.Type) {
        register(UINib(nibName: String(describing: cell), bundle: nil), forCellWithReuseIdentifier: String(describing: cell))
    }
    
    func registerClassWithCell<T: UICollectionViewCell>(_ cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: String(describing: cell))
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cell), for: indexPath) as! T
    }
    
    func registerNibWithReusableView<T: UICollectionReusableView>(_ cell: T.Type, forSupplementaryViewOfKind kind: String) {
        register(UINib(nibName: String(describing: cell), bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: cell))
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(_ cell: T.Type,  ofKind kind: String, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: cell), for: indexPath) as! T
    }
    
    func registerClassWithReusableView<T: UICollectionReusableView>(_ cell: T.Type, forSupplementaryViewOfKind kind: String) {
        register(cell, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: cell))
    }

}

extension String {
    func width(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func width(font: UIFont, height: CGFloat = 15) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    
    func height(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    var isEmpty: Bool {
        let set = CharacterSet.whitespacesAndNewlines
        let new = trimmingCharacters(in: set)
        return new.count <= 0
    }
    
    func withlineSpacing(_ space: CGFloat) -> NSAttributedString {
        let atrrStr = NSMutableAttributedString(string: self)
        let paragrapStyle = NSMutableParagraphStyle()
        paragrapStyle.lineBreakMode = .byTruncatingTail
        paragrapStyle.lineSpacing = space
        atrrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapStyle, range: NSRange(location: 0, length: self.count))
        return atrrStr
    }
    
    func splite(_ space: Int) -> [String] {
        var groupStrs: [String] = []
        for index in stride(from: 0, to: count, by: space) {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            var endIndex = self.endIndex
            if let currentIndex = self.index(startIndex, offsetBy: space, limitedBy: self.endIndex) {
                endIndex = currentIndex
            }
            let subStr = self[startIndex ..< endIndex]
            groupStrs.append(String(subStr))
         
        }
        return groupStrs
    }
}


extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
