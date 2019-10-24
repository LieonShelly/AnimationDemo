//
//  IFExtension.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func width(attributes: [NSAttributedString.Key : Any], height: CGFloat) -> CGFloat {
        let rect = (self as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height),
                options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading],
                context: nil)
        return ceil(rect.size.width * rect.size.height / height)
     }
    
    func height(attributes: [NSAttributedString.Key : Any], width: CGFloat) -> CGFloat {
        let rect = (self as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                             options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading],
               context: nil)
           return ceil(rect.size.width * rect.size.height / width)
       }
    
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
    
    func withlineSpacing(_ space: CGFloat) -> (NSAttributedString, NSMutableParagraphStyle) {
        let atrrStr = NSMutableAttributedString(string: self)
        let paragrapStyle = NSMutableParagraphStyle()
        paragrapStyle.lineBreakMode = .byTruncatingTail
        paragrapStyle.lineSpacing = space
        atrrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapStyle, range: NSRange(location: 0, length: self.count))
        return (atrrStr, paragrapStyle)
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
