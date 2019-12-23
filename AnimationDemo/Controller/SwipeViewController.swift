
//
//  SwipeViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/12/10.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SwipeViewController: UIViewController {
    struct UISize {
        static let navBarHeight: CGFloat = UIDevice.current.isiPhoneXSeries ? 112 : 88
        static let expandNavbarHeight: CGFloat = UIDevice.current.isiPhoneXSeries ? 162 : 132
        static let iconHeight: CGFloat = 46
        static let existBtnContainerWidth: CGFloat = 120
        static let rightInset: CGFloat = 8
    }
    let bag = DisposeBag()
    var startPosition: CGPoint = .zero
    var endPosition: CGPoint = .zero
    fileprivate lazy var red: UIView = {
        let red = UIView()
        red.backgroundColor = UIColor.red
        return red
    }()
    fileprivate lazy var yellow: UIView = {
        let red = UIView()
        red.backgroundColor = UIColor.yellow
        return red
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(red)
        view.addSubview(yellow)
        
        red.snp.makeConstraints {
            $0.left.equalTo(8)
            $0.right.equalTo(-8)
            $0.height.equalTo(80)
            $0.top.equalTo(100)
        }
        
        yellow.snp.makeConstraints {
            $0.left.equalTo(red.snp.right).offset(8)
            $0.height.equalTo(red.snp.height)
            $0.width.equalTo(UISize.existBtnContainerWidth)
            $0.centerY.equalTo(red.snp.centerY)
        }
        
        let pan = UIPanGestureRecognizer()
        
        red.addGestureRecognizer(pan)
        pan.rx.event
            .subscribe(onNext: panAction)
            .disposed(by: bag)
        pan.rx.event
            .subscribe(onNext: panAction)
            .disposed(by: bag)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showExistViewAnimation()
    }
    
    
    fileprivate func showExistViewAnimation() {
        let initContentOffsetX: CGFloat = 40
        let shakingInset: CGFloat =  UISize.rightInset
        /// 出现
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [],
                       animations: {
                        self.red.frame.origin.x -= initContentOffsetX
                        self.yellow.frame.origin.x = self.red.frame.maxX + UISize.rightInset + shakingInset
                        
        }, completion: nil)
        /// 抖动
        UIView.animate(withDuration: 1.5, delay: 0.25, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            self.yellow.frame.origin.x -= (shakingInset)
        }, completion: {_ in
        })
        /// 复位
        UIView.animate(withDuration: 0.25,
                       delay: 1.75,
                       options: [],
                       animations: {
                        self.red.frame.origin.x = UISize.rightInset
                        self.yellow.frame.origin.x = self.red.frame.maxX + UISize.rightInset + shakingInset
        }, completion: nil)
        
    }
    
    @objc
    fileprivate func panAction(_ pan: UIPanGestureRecognizer) {
        var postion = pan.location(in: pan.view)
        postion = view.convert(postion, from: pan.view)
        let velocity = pan.velocity(in: pan.view)
        let totoalOffset =  UISize.existBtnContainerWidth
        switch pan.state {
        case .began:
            if velocity.x < 0 {
                UIView.animate(withDuration: 0.5, delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0,
                               options: [.curveEaseInOut],
                               animations: {
                                self.red.frame.origin.x = -totoalOffset
                                self.yellow.frame.origin.x = self.red.frame.maxX + UISize.rightInset
                }, completion: nil)
            } else if velocity.x > 0 {
                UIView.animate(withDuration: 0.5, delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0,
                               options: [.curveEaseInOut],
                               animations: {
                                self.red.frame.origin.x = UISize.rightInset
                                self.yellow.frame.origin.x = self.red.frame.maxX + UISize.rightInset
                }, completion: nil)
            }
            startPosition = postion
        case .changed:
            
              return;
              
              
            endPosition = postion
            var offsetX = endPosition.x - startPosition.x
            debugPrint("offsetX:\(offsetX) - pan:\(pan.velocity(in: pan.view).x)")
            if velocity.x < 0 { // 向左
                offsetX = abs(offsetX)
                if offsetX >= totoalOffset {
                    offsetX = totoalOffset
                }
                red.frame.origin.x = -offsetX
                yellow.frame.origin.x =  red.frame.maxX + UISize.rightInset
            } else if velocity.x > 0 {
                if red.frame.origin.x >= UISize.rightInset {
                    offsetX = UISize.rightInset
                }
                let leftFinalX = -totoalOffset
                red.frame.origin.x = leftFinalX + offsetX
                yellow.frame.origin.x =  red.frame.maxX + UISize.rightInset
            }
        case .ended:
            
            return;
            
            
            
            endPosition = postion
            let offsetX = abs(endPosition.x - startPosition.x)
            
            if velocity.x < 0 {
                if offsetX >= totoalOffset * 0.2 {
                    UIView.animate(withDuration: 0.25, delay: 0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 20,
                                   options: [.transitionCrossDissolve],
                                   animations: {
                                    self.red.frame.origin.x = -totoalOffset
                                    self.yellow.frame.origin.x = self.red.frame.maxX + UISize.rightInset
                    }, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.25, delay: 0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 20,
                                   options: [.transitionCrossDissolve],
                                   animations: {
                                    self.red.frame.origin.x = UISize.rightInset
                                    self.yellow.frame.origin.x = self.red.frame.maxX + UISize.rightInset
                    }, completion: nil)
                }
            } else if velocity.x > 0 {
                if offsetX < totoalOffset * 0.2 {
                    UIView.animate(withDuration: 0.25,
                                   delay: 0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 20,
                                   options: [.transitionCrossDissolve],
                                   animations: {
                                    self.red.frame.origin.x = -totoalOffset
                                    self.yellow.frame.origin.x = self.red.frame.maxX + UISize.rightInset
                    }, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.25, delay: 0,
                                   usingSpringWithDamping: 0.8,
                                   initialSpringVelocity: 20,
                                   options: [.transitionCrossDissolve],
                                   animations: {
                                    self.red.frame.origin.x = UISize.rightInset
                                    self.yellow.frame.origin.x = self.red.frame.maxX + UISize.rightInset
                    }, completion: nil)
                }
            }
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}



/**
 气泡页面出来后，圈圈呼吸动画
 1 必点：点击a圈圈响应相应控件的事件，点击圈圈以外气泡抖动
 2 非必点：点击圈圈响应事件，点击圈圈以外页面消失
 */

class FXTutorialDotTipPop: UIView, AnimationBase {
    enum DotDirection {
        case down(dotCenter: CGPoint, controlSize: CGSize)
        case up(dotCenter: CGPoint, controlSize: CGSize)
        case none
    }
    fileprivate var isRequredClick: Bool = false
    var dismissHandler: (() -> Void)?
    var dotClickHandler: (() -> Void)?
    
    struct UISize {
        static let titleInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        static let popHorisonInset: CGFloat = 48
        static let verticalPadding: CGFloat = 20
        static let dotInnerPadding: CGFloat = FXDoubleCycleView.borderSize
        static let dotMinHeight: CGFloat = 48
    }
    fileprivate var direction: DotDirection = .none
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        return titleLabel
    }()
    fileprivate lazy var labelContainer: FXGradientLabel = {
        let labelContainer = FXGradientLabel()
        labelContainer.layer.cornerRadius = 8
        labelContainer.layer.masksToBounds = true
        return labelContainer
    }()
    fileprivate lazy var dot: FXDoubleCycleView = {
        let dot = FXDoubleCycleView()
        return dot
    }()
    fileprivate lazy var emptyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(self.emptyAreaClick), for: .touchUpInside)
        return btn
    }()
    
    convenience init(_ text: String,
                     isRequredClick: Bool = false,
                     direction: DotDirection) {
        self.init(frame: UIScreen.main.bounds)
        self.isRequredClick = isRequredClick
        configUI(direction, text: text)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emptyBtn.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(emptyBtn)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    static func show(_ text: String,
                     direction: DotDirection,
                     isRequredClick: Bool = false,
                     dotClickHandler: (() -> Void)? = nil,
                     dismissHandler: (() -> Void)? = nil) -> FXTutorialDotTipPop {
        let keyWindow = UIApplication.shared.keyWindow!
        let pop = FXTutorialDotTipPop(text, isRequredClick: isRequredClick, direction: direction)
        pop.dismissHandler = dismissHandler
        pop.dotClickHandler = dotClickHandler
        keyWindow.addSubview(pop)
        keyWindow.bringSubviewToFront(pop)
        return pop
    }
    
}

extension FXTutorialDotTipPop {
    fileprivate func configUI(_ direction: DotDirection, text: String) {
        titleLabel.text = text
        switch direction {
        case .down(dotCenter: let dotCenter, controlSize: let controlSize):
            let dotSize = CGSize(width: controlSize.width,
                                 height: controlSize.height)
            let dotOrigin = CGPoint(x: dotCenter.x - dotSize.width * 0.5, y: dotCenter.y - dotSize.height * 0.5)
            dot = FXDoubleCycleView(frame: CGRect(origin: dotOrigin, size: dotSize))
            addSubview(dot)
            
            let textAttr = NSMutableAttributedString(string: text)
            textAttr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: text.count))
            let maxWidth: CGFloat = frame.size.width - UISize.popHorisonInset * 2
            let textSize = textAttr.boundingRect(with: CGSize(width: maxWidth, height: .infinity), options: [.usesLineFragmentOrigin], context: nil).size
            titleLabel.frame.origin = CGPoint(x: UISize.titleInset.left, y: UISize.titleInset.top)
            titleLabel.frame.size = textSize
            labelContainer.frame.size = CGSize(width: textSize.width + UISize.titleInset.right + UISize.titleInset.left,
                                               height: textSize.height + UISize.titleInset.bottom + UISize.titleInset.top)
            if labelContainer.frame.size.height < UISize.dotMinHeight {
                labelContainer.frame.size.height = UISize.dotMinHeight
                titleLabel.center.y = UISize.dotMinHeight * 0.5
            }
            labelContainer.center.x = frame.width * 0.5
            labelContainer.frame.origin.y = dot.frame.minY - UISize.verticalPadding - UISize.dotMinHeight
            addSubview(labelContainer)
            labelContainer.addSubview(titleLabel)
        case .up(dotCenter: let dotCenter, controlSize: let controlSize):
            let dotSize = CGSize(width: controlSize.width,
                                 height: controlSize.height)
            let dotOrigin = CGPoint(x: dotCenter.x - dotSize.width * 0.5, y: dotCenter.y - dotSize.height * 0.5)
            dot = FXDoubleCycleView(frame: CGRect(origin: dotOrigin, size: dotSize))
            addSubview(dot)
            let textAttr = NSMutableAttributedString(string: text)
            textAttr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: text.count))
            let maxWidth: CGFloat = frame.size.width - UISize.popHorisonInset * 2
            let textSize = textAttr.boundingRect(with: CGSize(width: maxWidth, height: .infinity), options: [.usesLineFragmentOrigin], context: nil).size
            titleLabel.frame.origin = CGPoint(x: UISize.titleInset.left, y: UISize.titleInset.top)
            titleLabel.frame.size = textSize
            labelContainer.frame.size = CGSize(width: textSize.width + UISize.titleInset.right + UISize.titleInset.left,
                                               height: textSize.height + UISize.titleInset.bottom + UISize.titleInset.top)
            if labelContainer.frame.size.height < UISize.dotMinHeight {
                labelContainer.frame.size.height = UISize.dotMinHeight
                titleLabel.center.y = UISize.dotMinHeight * 0.5
            }
            labelContainer.center.x = frame.width * 0.5
            labelContainer.frame.origin.y = dot.frame.maxY + UISize.verticalPadding
            addSubview(labelContainer)
            labelContainer.addSubview(titleLabel)
        default:
            break
        }
        showAnimation(labelContainer, direction: direction)
        let dotTap = UITapGestureRecognizer(target: self, action: #selector(dotClickAction))
        dot.isUserInteractionEnabled = true
        dot.addGestureRecognizer(dotTap)
    }
    
    @objc func dismiss(_ callDismissBack: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0, y: 0)
        })
        if callDismissBack {
            delay(seconds: 0.25) {
                self.dismissHandler?()
            }
            delay(seconds: 0.5) {
                self.removeFromSuperview()
            }
        } else {
            delay(seconds: 0.25) {
                self.removeFromSuperview()
            }
        }
        
    }
    
    @objc
    fileprivate func dotClickAction() {
        dotClickHandler?()
        dismiss(false)
    }
    
    @objc
    fileprivate func emptyAreaClick() {
        if isRequredClick {
            labelContainer.shakeAnimation(2)
        } else {
            dismiss(true)
        }
    }
    
    fileprivate func showAnimation(_ view: UIView, direction: DotDirection) {
        let bgView = view
        let anchorPoint = PopSerivce.getAnchorPoint(direction)
        bgView.layer.anchorPoint = anchorPoint
        bgView.frame.origin.x = bgView.layer.position.x - 0.5 * bgView.bounds.width
        bgView.frame.origin.y = bgView.layer.position.y - 0.5 * bgView.bounds.height
        bgView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.25) {
            bgView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

class FXGradientLabel: UIView {
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.opacity = 0.95
        return gradientLayer
    }()
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

class FXDoubleCycleView: UIView {
    
    struct UISize {
        static let outterShapeWidth: CGFloat = 2
        static let innerShapeWidth: CGFloat = outterShapeWidth * 2
        static let outterClearCycleWidth: CGFloat = 5
    }
    
    static var borderSize: CGFloat {
        return UISize.outterShapeWidth + UISize.innerShapeWidth + UISize.outterClearCycleWidth
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    fileprivate lazy var outerCycle: CAGradientLayer = {
        return createGrdientLayer()
    }()
    fileprivate lazy var innerLayer: CAGradientLayer = {
        return createGrdientLayer()
    }()
    fileprivate lazy var outterShapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.borderWidth =  UISize.outterShapeWidth
        shapeLayer.masksToBounds = true
        return shapeLayer
    }()
    fileprivate lazy var innerShapeLayer: CAShapeLayer = {
        let innerShapeLayer = CAShapeLayer()
        innerShapeLayer.borderWidth =  UISize.innerShapeWidth
        innerShapeLayer.masksToBounds = true
        return innerShapeLayer
    }()
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        outerCycle.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        outerCycle.cornerRadius = frame.width * 0.5
        layer.addSublayer(outerCycle)
        
        outterShapeLayer.frame = bounds
        outterShapeLayer.cornerRadius = bounds.height * 0.5
        outerCycle.mask = outterShapeLayer
        
        let innerLayerPosition = UISize.outterClearCycleWidth +  UISize.outterShapeWidth
        let innerLayerWidth = frame.width - ( UISize.outterClearCycleWidth +  UISize.outterShapeWidth) * 2
        innerLayer.frame = CGRect(x: innerLayerPosition,
                                  y: innerLayerPosition,
                                  width: innerLayerWidth,
                                  height: innerLayerWidth)
        innerLayer.cornerRadius = innerLayerWidth * 0.5
        layer.addSublayer(innerLayer)
        
        innerShapeLayer.frame = innerLayer.bounds
        innerShapeLayer.cornerRadius = innerLayerWidth * 0.5
        innerLayer.mask = innerShapeLayer
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        superview?.willMove(toSuperview: newSuperview)
        showAniamtion()
    }
    
    fileprivate func createGrdientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }
    
    fileprivate func showAniamtion() {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 1.2
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.autoreverses = true
        scale.duration = 1
        scale.repeatCount = Float.infinity
        layer.add(scale, forKey: nil)
    }
    
}


class FXOneCycleView: UIView {
    
    struct UISize {
        static let outterShapeWidth: CGFloat = 2
        static let innerShapeWidth: CGFloat = outterShapeWidth * 2
        static let outterClearCycleWidth: CGFloat = 5
    }
    
    static var borderSize: CGFloat {
        return UISize.outterShapeWidth + UISize.innerShapeWidth + UISize.outterClearCycleWidth
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    fileprivate lazy var outerCycle: CAGradientLayer = {
        return createGrdientLayer()
    }()

    fileprivate lazy var outterShapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.borderWidth =  UISize.outterShapeWidth
        shapeLayer.masksToBounds = true
        return shapeLayer
    }()

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        outerCycle.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        outerCycle.cornerRadius = frame.width * 0.5
        layer.addSublayer(outerCycle)
        
        outterShapeLayer.frame = bounds
        outterShapeLayer.cornerRadius = bounds.height * 0.5
        outerCycle.mask = outterShapeLayer
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        superview?.willMove(toSuperview: newSuperview)
    }
    
    fileprivate func createGrdientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }
    
    func showAniamtion() {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 1.2
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scale.autoreverses = true
        scale.duration = 1
        scale.repeatCount = Float.infinity
        layer.add(scale, forKey: nil)
    }
    
}



extension UIView {
    public func addPartialRoundedCorners(OnCorners corners: UIRectCorner, andCornerRadius cornerRadius: CGSize) {
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadius)
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = maskPath.cgPath
        self.layer.mask = shapeLayer
    }
    
    // 360度旋转图片
    public func rotate360Degree(_ mDuration: CFTimeInterval = 2.6) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0) // 旋转角度
        rotationAnimation.duration = mDuration // 旋转周期
        rotationAnimation.isCumulative = true // 旋转累加角度
        rotationAnimation.repeatCount = 100000 // 旋转次数
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    // 左右晃动动画
    public func shakeAnimation(_ repeatNum: Int) {
        let momAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        momAnimation.fromValue = NSNumber(value: -0.1) // 左幅度
        momAnimation.toValue = NSNumber(value: 0.1) // 右幅度
        momAnimation.duration = 0.1
        momAnimation.repeatCount = Float(repeatNum) // 无限重复
        momAnimation.autoreverses = true // 动画结束时执行逆动画
        layer.add(momAnimation, forKey: "centerLayer")
    }
    // 停止旋转
    public func stopRotate() {
        layer.removeAllAnimations()
    }
    
}
