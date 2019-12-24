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
/**
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
**/
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



//
//  UIColorExtension.swift
//  Camera360
//
//  Created by goingta on 22/11/2017.
//  Copyright © 2017 Pinguo. All rights reserved.
//

import Foundation
import UIKit

private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

public extension UIColor {
    static var them: UIColor? {
        return UIColor(named: "themColor")
    }
    fileprivate convenience init?(hex3: Int, alpha: Float) {
        self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                  alpha: CGFloat(alpha))
    }
    
    fileprivate convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }
    
    convenience init?(hexString: String, alpha: Float = 1.0) {
        var hex:String = hexString
        
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        } else {
            // 前后空格
            if hex.count > 6 {
                hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
                if hex.hasPrefix("#") {
                    hex = String(hex[hex.index(after: hex.startIndex)...])
                }
            }
        }
        
        
        // 解析透明度
        var alp: Float = alpha
        
        if hex.count == 8{
            let temp = String.init(hex.suffix(2))
            if let hexVal = Int(temp, radix: 16) {
                alp = Float(hexVal)/255
            }
            
            hex = String.init(hex.prefix(6))
        }
        
        guard let hexVal = Int(hex, radix: 16) else {
            self.init()
            return nil
        }
        
        switch hex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alp)
        case 6:
            self.init(hex6: hexVal, alpha: alp)
        default:
            self.init()
            return nil
        }
    }
    
    convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    convenience init?(hex: Int, alpha: Float) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: hex, alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
    
    /**
     通过rgba创建color
     - Parameters:
     - R: 红色通道值 0~255
     - G: 绿色通道值 0~255
     - B: 蓝色通道值 0~255
     - Returns: UIColor
     - Throws: nil
     
     - Authors: Bob
     - Date: 2019
     */
    convenience init?(_ R: UInt8, G: UInt8, B: UInt8, A: UInt8 = 255) {
        let r = CGFloat(R)/255
        let g = CGFloat(G)/255
        let b = CGFloat(B)/255
        let a = CGFloat(A)/255
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    
}

