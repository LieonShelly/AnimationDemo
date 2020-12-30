//
//  FuncCoding.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/28.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import CoreImage

typealias Filter = (CIImage) -> CIImage

func testFilter() {
    func blur(radius: Double) -> Filter {
        return  { image in
            let parameter: [String : Any] = [kCIInputRadiusKey: radius, kCIInputImageKey: image]
            guard let filter = CIFilter(name: "GIGaussianBlur", parameters: parameter) else {
                fatalError()
            }
            guard let outImg = filter.outputImage else {
                fatalError()
            }
            return outImg
        }
    }
    
    func colorGenerator(color: UIColor) -> Filter {
        return { _ in
            let c = CIColor(cgColor: color.cgColor)
            let param = [kCIInputColorKey: c]
            guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: param) else {
                fatalError()
            }
            guard let outImg = filter.outputImage else {
                fatalError()
            }
            return outImg
        }
    }
    
    func compositeSourceOver(overlayer: CIImage) -> Filter {
        return { image in
            let param: [String: Any] = [kCIInputBackgroundImageKey: image,
                                        kCIInputBackgroundImageKey: overlayer]
            guard let filter = CIFilter(name: "CISourceOverCompositing", parameters: param) else { fatalError() }
            guard let outputImage = filter.outputImage else { fatalError() }
            let cropRect = image.extent
            return outputImage.cropped(to: cropRect)
        }
    }
    
    func colorOverlay(color: UIColor) -> Filter {
        return { image in
            let overlay = colorGenerator(color: color)(image)
            return compositeSourceOver(overlayer: overlay)(image)
        }
    }
    
    func composeFilters(_ filter1: @escaping Filter, _ filter2: @escaping Filter) -> Filter {
        return { image in filter2(filter1(image)) }
    }
    
    func test() {
        let url = URL(string: "")
        let image = CIImage(contentsOf: url!)!
        let overlayColor = UIColor.red.withAlphaComponent(0.2)
        let bluredImage = blur(radius: 20)(image)
        let overlaidImage = colorOverlay(color: overlayColor)(bluredImage)
        
        let composeFilter = composeFilters(blur(radius: 20), colorOverlay(color: overlayColor))
        let result = composeFilter(image)
        
       let myFilter2 = blur(radius: 2) >>> colorOverlay(color: overlayColor)
        myFilter2(image)
    }
    
  
    
}

precedencegroup leftPrecedence {
    associativity: left
}

infix operator >>>: leftPrecedence

func >>>(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}

/**
 # 科里化
 - 将多参数单函数运算过程转换为多函数单参数的运算过程
 */

func testCurrying() {
    func add1(x: Int, y: Int) -> Int {
        return x + y
    }
    
    // A -> (B -> C)
    func add2(x: Int) -> (Int) -> Int {
        return { y in  return x + y }
    }
    
    add2(x: 2)(2)
}

func testMapReduce() {
    func computeArrays(xs: [Int], transform: (Int) -> Int) -> [Int] {
        var results: [Int] = []
        for x in xs {
            results.append(transform(x))
        }
        return results
    }
    
    func douleArray2(xs: [Int]) -> [Int] {
        computeArrays(xs: xs, transform: { $0 * 2 })
    }
}
