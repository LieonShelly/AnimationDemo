//
//  CustomViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/22.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        let test = FXGradientBorderView(5)
        test.backgroundColor = .white
        test.frame = CGRect(x: view.center.x - 40, y: view.center.y - 40, width: 80, height: 80)
        view.addSubview(test)
        
    }
    

    
}

class FXGradientBorderView: UIView {
    fileprivate var innerInset: CGFloat = 5
    fileprivate lazy var gradientLayer: CAGradientLayer = {
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = [
           UIColor(hex: 0x54d5ef)!.cgColor,
           UIColor(hex: 0x54ecef)!.cgColor,
           UIColor(hex: 0xd79afb)!.cgColor,
           UIColor(hex: 0xff82ff)!.cgColor,
           UIColor(hex: 0xd795fb)!.cgColor,
           UIColor(hex: 0x54d5ef)!.cgColor,
           UIColor(hex: 0x54d5ef)!.cgColor,
       ]
       gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
       gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
       gradientLayer.locations = [0, 0.16, 0.4, 0.5, 0.61, 0.83, 1]
       return gradientLayer
   }()
    
    fileprivate lazy var pathLayer: CAShapeLayer = {
        let pathLayer = CAShapeLayer()
        pathLayer.fillColor = UIColor.clear.cgColor
             pathLayer.strokeColor = UIColor.clear.cgColor
        return pathLayer
    }()
    
    convenience init(_ inset: CGFloat) {
        self.init()
        self.innerInset = inset
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI(innerInset, frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let innerFrame = bounds
                 .insetBy(dx: innerInset, dy: innerInset)
        let cyclePath = UIBezierPath(roundedRect: innerFrame, cornerRadius: innerFrame.width * 0.5)
        pathLayer.path = cyclePath.cgPath
    }
    
    
    fileprivate func configUI(_ inset: CGFloat, frame: CGRect) {
        layer.addSublayer(gradientLayer)
        layer.mask = pathLayer
    }
   
}



import UIKit

public enum GradientButtonShadowType: Int {
    case none
    case normal
    case gradient
}

public class GradientButton: UIButton {
    
    var gradientColors: [UIColor] = []
    var shadowColor: UIColor?
    var shadowRadius: CGFloat = 20
    var shadowOpacity: CGFloat = 0.4
    var cornerRadius: CGFloat = 0.0
    var shadowOffset: CGSize = CGSize.init(width: 0, height: 10)
    var showBottomShadow: GradientButtonShadowType = .none
    
    var layoutedSubviews: Bool = false
    var layoutedSublayers: Bool = false
    var lastBounds: CGRect = CGRect.zero // bob 2019-07-29 如果按钮的大小变化了，需要更新背景
    
    /** 是否展示渐变边框，中间镂空 */
    private(set) var isBouderOut: Bool = false
    private var borderLayer: CAGradientLayer?
    
    private lazy var bottomShadowLayer: CALayer = {
        $0.contents = UIImage.init(named: "bottom_shadow")?.cgImage
        return $0
    }(CALayer.init())
    
    public convenience init(button type: ButtonType,
                            showBottom shadow: GradientButtonShadowType = .normal,
                            corner radius: CGFloat = 10.0,
                            gradient colors: [UIColor] = [UIColor.init(hex: 0x7AD3FF)!,
                                                          UIColor.init(hex: 0xE261DD)!],
                            shadow color: UIColor? = UIColor.init(hex: 0xB196ED),
                            shadowRadius: CGFloat = 20,
                            shadowOpacity: CGFloat = 0.4,
                            shadowOffset: CGSize = CGSize.init(width: 0, height: 10),
                            borderOut: Bool = false) {
        self.init(type: type)
        gradientColors = colors
        cornerRadius = radius
        showBottomShadow = shadow
        shadowColor = color
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        isBouderOut = borderOut
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isBouderOut && (!layoutedSubviews || !lastBounds.equalTo(bounds)) {
            layoutedSubviews = true
            lastBounds = bounds
            
            let gradientLayer: CAGradientLayer = CAGradientLayer.init()
            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = cornerRadius
            gradientLayer.colors = gradientColors.map{$0.cgColor}
            gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
            
            // bob 添加集中状态的效果与设计一致
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .normal)
            gradientLayer.opacity = 0.5
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .highlighted)
            gradientLayer.opacity = 0.2
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .disabled)
        }
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if isBouderOut {
            if layer == self.layer {
                let rect = layer.bounds
                
                if borderLayer == nil {
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.borderWidth = 1
                    shapeLayer.masksToBounds = true
                    shapeLayer.cornerRadius = cornerRadius
                    
                    let gradientLayer = CAGradientLayer()
                    gradientLayer.colors = gradientColors.map{ $0.cgColor }
                    gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
                    gradientLayer.mask = shapeLayer
                    borderLayer = gradientLayer
                    self.layer.addSublayer(gradientLayer)
                }
                
                borderLayer?.frame = rect
                borderLayer?.mask?.frame = rect
            }
        } else if !layoutedSublayers || !lastBounds.equalTo(bounds) {
            layoutedSublayers = true
            switch showBottomShadow {
            case .gradient:
                bottomShadowLayer.frame = CGRect.init(x: 0, y: bounds.size.height - 2, width: bounds.size.width, height: 7.0)
                layer.insertSublayer(bottomShadowLayer, at: 0)
            case .normal:
                layer.shadowOffset = shadowOffset
                layer.shadowRadius = shadowRadius
                layer.shadowOpacity = Float(shadowOpacity)
                layer.shadowColor = shadowColor?.cgColor
            default:
                break
            }
        }
    }
}

internal extension UIImage {
    static func imageFrom(layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size,
                                               layer.isOpaque,
                                               UIScreen.main.scale)
        
        defer { UIGraphicsEndImageContext() }
        
        // Don't proceed unless we have context
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

