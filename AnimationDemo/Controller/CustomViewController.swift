//
//  CustomViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/22.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomViewController: UIViewController {
    fileprivate lazy var redView: FXAnimtaeLayer = {
        let view = FXAnimtaeLayer(CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY))
        view.backgroundColor = UIColor.red
        return view
    }()
    
    let bag = DisposeBag()
    fileprivate lazy var bottomBgImageView: UIImageView = {
        let bottomBgImageView = UIImageView()
        bottomBgImageView.backgroundColor = UIColor.gray
        bottomBgImageView.image = UIImage(named: "meinv")
        bottomBgImageView.alpha = 0
        return bottomBgImageView
    }()
    fileprivate lazy var bottomBlackView: UIView = {
        let bottomBlackView = UIView()
        bottomBlackView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        bottomBlackView.alpha = 0
        return bottomBlackView
    }()
    fileprivate lazy var bottomFlurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let effect = UIBlurEffect(style: .light)
        view.alpha = 0
        view.effect = effect
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        //        let test = FXGradientBorderView(5)
        //        test.backgroundColor = .clear
        //        test.frame = CGRect(x: view.center.x - 40, y: view.center.y - 40, width: 80, height: 80)
        //        view.addSubview(test)
        //
        //        let imageView = UIImageView(frame: CGRect(x: view.center.x + 40, y: view.center.y + 40, width: 100, height: 100))
        //        let image = UIImage(named: "picDownload")
        //        imageView.image = image
        //        view.addSubview(imageView)
        //
        //        let strchimageView = UIImageView(frame: CGRect(x: 20, y: view.center.y + 200, width: 230, height: 70))
        //        strchimageView.image = image?.stretchableImage(withLeftCapWidth: Int(image!.size.width * 0.3), topCapHeight: 0)
        //        view.addSubview(strchimageView)
        view.addSubview(redView)
        view.addSubview(bottomBgImageView)
        
        view.addSubview(bottomFlurView)
        view.addSubview(bottomBlackView)
        redView.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.size.equalTo(CGSize(width: 200, height: 200))
        }
        bottomBgImageView.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.size.equalTo(CGSize(width: 50, height: 50))
        }
        bottomBlackView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        bottomFlurView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .blue
        btn.setTitle("确定", for: .normal)
        
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.top.equalTo(100)
        }
        
        btn.rx.tap
            .subscribe(onNext: { (_) in
                FXTutorialDotTipPop.show("asdfasd", direction: .up(dotCenter: btn.center, controlSize: btn.frame.size), dismissHandler: nil)
            })
            .disposed(by: bag)
    }
    
    var index: CGFloat = 0
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let selectedFrame = CGRect(x: 200, y: 200, width: 50, height: 50)
        let initialFrame = selectedFrame
        let offsetY: CGFloat = 200
        let finalFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - offsetY)
        bottomBgImageView.alpha = 1
        bottomBgImageView.frame = initialFrame
        bottomBgImageView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        UIView.animate(withDuration: 3,
                       delay: 0,
                  options: [.transitionCrossDissolve],
                  animations: {
                    self.bottomBgImageView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY - offsetY * 0.5)
            self.bottomBgImageView.transform = CGAffineTransform(scaleX: finalFrame.width / selectedFrame.width, y: finalFrame.height / selectedFrame.height)
        }, completion: { _ in
            
        })
        bottomBlackView.alpha = 0
        bottomFlurView.alpha = 0
        UIView.animate(withDuration: 1,
                       delay: 2,
                        options: [.transitionCrossDissolve],
                        animations: {
                  self.bottomFlurView.alpha = 1
                  self.bottomBlackView.alpha = 1
          }, completion: { _ in
              
          })
    }
    
    
}

class FXGradientBorderView: UIView {
    fileprivate var innerInset: CGFloat = 5
    fileprivate var borderWidth: CGFloat = 5
    
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: 0x54d5ef)!.withAlphaComponent(0).cgColor,
            UIColor(hex: 0x54ecef)!.cgColor,
            UIColor(hex: 0xd79afb)!.cgColor,
            UIColor(hex: 0xd795fb)!.cgColor,
            UIColor(hex: 0x54d5ef)!.cgColor,
            UIColor(hex: 0x54d5ef)!.withAlphaComponent(0).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.2)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.6)
        gradientLayer.locations = [0, 0, 0.08, 0.6, 1, 1]
        return gradientLayer
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .red
        return contentView
    }()
    
    convenience init(_ inset: CGFloat, borderWidth: CGFloat = 5) {
        self.init()
        self.innerInset = inset
        self.borderWidth = borderWidth
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentFrame = bounds.insetBy(dx: innerInset + borderWidth, dy: innerInset + borderWidth)
        contentView.layer.cornerRadius = contentFrame.width * 0.5
        contentView.layer.masksToBounds = true
        contentView.frame = contentFrame
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        layer.cornerRadius = bounds.width * 0.5
        layer.masksToBounds = true
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.borderWidth = 3
        shapeLayer.masksToBounds = true
        shapeLayer.frame = bounds
        shapeLayer.cornerRadius = bounds.height * 0.5
        gradientLayer.mask = shapeLayer
        
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
    var borderLayer: CAGradientLayer?
    var gradientLayer: CAGradientLayer!
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
            
            gradientLayer = CAGradientLayer.init()
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

