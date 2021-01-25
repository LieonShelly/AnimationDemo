
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


public class IFButton: UIButton {
    private var styleConfig: ((_ uiStyle: IFUserInterfaceStyle, _ state: UIControl.State) -> IFButtonStyle?)?
    public var userInterfaceStyle: IFUserInterfaceStyle = .unspecified
    private var hasAppliedStyle: Bool = false
    private var shouldApplyStyle: Bool = true
    private var fontSize: CGFloat?
    private var defaultStyle: IFButtonStyle = .common
    /// 基础黑色风格改版字体大小
    convenience public init(fontSize: CGFloat) {
        self.init(type: .custom)
        self.fontSize = fontSize
    }
    /// 自定义风格，可改字体大小
    convenience public init(style: IFButtonStyle, fontSize: CGFloat? = nil) {
        self.init(type: .custom)
        defaultStyle = style
        self.fontSize = fontSize
    }
    /// 是否应用默认风格
    convenience public init(shouldApplyStyle: Bool) {
        self.init(type: .custom)
        self.shouldApplyStyle = shouldApplyStyle
    }
    
    convenience public init(styleConfig: @escaping (_ uiStyle: IFUserInterfaceStyle, _ state: UIControl.State) -> IFButtonStyle?) {
        self.init(type: .custom)
        shouldApplyStyle = false
        self.styleConfig = styleConfig
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        IFThemeManager.registerVisitor(vistor: self)
        builtStyle()
    }
    
    private func builtStyle() {
        guard shouldApplyStyle else {
            return
        }
        // default style apply
        configStyle { [weak self] (uiStyle, state) -> IFButtonStyle? in
            if state == .normal {
                if let fsize = self?.fontSize {
                    return self?.defaultStyle.adapt(fontSize: fsize)
                } else {
                    return self?.defaultStyle
                }
            } else {
                return nil
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !hasAppliedStyle {
            hasAppliedStyle = true
            adaptState()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        IFThemeManager.registerVisitor(vistor: self)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        styleConfig = nil
    }
}

extension IFButton: IFThemeDelegate {
    
    /// 通过闭包让外界可以处理不同情况的样式
    /// - Parameter config: 不同style下的样式配置回调, state: 目前暂时不考虑状态变化的情况，内部默认应用状态值，通过透明度控制
    public func configStyle(config: @escaping (_ uiStyle: IFUserInterfaceStyle, _ state: UIControl.State) -> IFButtonStyle?) {
        styleConfig = config
    }
    
    private func adaptState() {
        let uiStyle = userInterfaceStyle == .unspecified ? IFThemeManager.currentUIStyle() : userInterfaceStyle
        if let style = styleConfig?(uiStyle, .normal) {
            setupStyle(style: style, state: .normal)
        }
        // 暂时不支持
//        if let style = styleConfig?(uiStyle, .selected) {
//            setupStyle(style: style, state: .selected)
//        }
//        if let style = styleConfig?(uiStyle, .disabled) {
//            setupStyle(style: style, state: .disabled)
//        }
//        if let style = styleConfig?(uiStyle, .highlighted) {
//            setupStyle(style: style, state: .highlighted)
//        }
    }
    
    public func didThemeChanged(_ uiStyle: IFUserInterfaceStyle) {
        adaptState()
    }
}


import UIKit

public struct IFButtonStyle {
    typealias PYAdaptStyle = IFButtonStyle
    /// 是否根据按钮状态外界单独控制样式，if true 需要外界提供不同状态的style
    public var applyStyleByState: Bool = false
    
    // readonly
    public var backgroundColor: IFColorStyle? {
        return viewStyle.backgroundColor
    }
    public var opacity: Float {
        return viewStyle.backgroundColor?.opacity ?? IFOpacity.full
    }
    public var textColor: IFColorStyle {
        return textStyle.colorStyle
    }
    public var fontSize: CGFloat {
        return textStyle.fontStyle.size
    }
    public var cornerRadius: CGFloat {
        return viewStyle.layerStyle?.cornerRadius ?? 0
    }
    public var font: UIFont {
        return textStyle.font
    }
    public  var foreColor: UIColor {
        return textStyle.color
    }
    
    var viewStyle: IFViewStyle
    var textStyle: IFTextStyle
    
    public func autoAdapt(_ adapt: Bool) -> IFButtonStyle {
        var style = self
        style.viewStyle = viewStyle.autoAdapt(adapt)
        style.textStyle = textStyle.autoAdapt(adapt)
        return style
    }
    
    public func adapt(shadow: IFShadowStyle?) -> IFButtonStyle {
        var style = self
        style.viewStyle = viewStyle.adapt(shadow: shadow)
        return style
    }
    
    public func adapt(viewStyle: IFViewStyle? = nil, textStyle: IFTextStyle? = nil) -> IFButtonStyle {
        var style = self
        if let vst = viewStyle {
            style.viewStyle = vst
        }
        if let tst = textStyle {
            style.textStyle = tst
        }
        return style
    }
    
    public func adapt(backgroundColor: IFColorStyle? = nil, cornerRadius: CGFloat? = nil, maskToBounds: Bool? = nil, textColor: IFColorStyle? = nil, fontSize: CGFloat? = nil) -> IFButtonStyle {
        let vStyle = viewStyle.adapt(backgroundColor: backgroundColor == nil ? nil : viewStyle.backgroundColor?.adapt(colorHex: backgroundColor?.colorHex,
                                                                                       colors: backgroundColor?.colorGradient,
                                                                                       opacity: backgroundColor?.opacity),
                                     cornerRadius: cornerRadius,
                                     masksToBounds: maskToBounds)
            
        let tStyle = textStyle.adapt(size: fontSize,
                                     color: textColor?.colorHex,
                                     opacity: textColor?.opacity)
        return IFButtonStyle(viewStyle: vStyle, textStyle: tStyle)
    }
}

extension IFButtonStyle {
    /// 错误情况
    public static let error = IFButtonStyle(viewStyle: IFViewStyle.error, textStyle: IFTextStyle.error)
    /// 普通按钮：黑色、文字金色medium
    public static let common = IFButtonStyle(viewStyle: IFViewStyle.button, textStyle: IFTextStyle.golden.adapt(weight: .medium))
    /// 白底、黑字
    public static let white = IFButtonStyle(viewStyle: IFViewStyle.white, textStyle: IFTextStyle.black)
    /// 黑底、白字
    public static let black = IFButtonStyle(viewStyle: IFViewStyle.black.autoAdapt(false), textStyle: IFTextStyle.white)
    /// 普通按钮：金色、文字白色medium
    public static let golden = IFButtonStyle(viewStyle: IFViewStyle.buttonGolded, textStyle: IFTextStyle.white.adapt(weight: .medium, color: .goldenBtnText))
    
    // MARK: - 自适应暗黑模式
    
    // alert
    /// 弹框普通按钮
    public static let alertCommon = common
    /// 弹框取消按钮
    public static let alertCancel = common.adapt(backgroundColor: IFColorStyle(colorHex: .grayCancelBg), textColor: IFColorStyle(colorHex: .grayText)).adapt(shadow: nil)
}


//
//  PYStyleDefine.swift
//  PYTheme
//
//  Created by Bob Lee on 2020/12/1.
//

import UIKit

public struct IFBorderStyle {
    public var color: IFColorStyle?
    public var width: CGFloat
    public var radius: CGFloat
    
    /// 普通
    public static let common: IFBorderStyle = IFBorderStyle(color: nil, width: IFBorderWidth.none, radius: IFCornerRadius.small)
    
    public func autoAdapt(_ adapt: Bool) -> IFBorderStyle {
        var style = self
        style.color = color?.autoAdapt(adapt)
        return style
    }
    
    public func adapt(radius: CGFloat) -> IFBorderStyle {
        var style = self
        style.radius = radius
        return style
    }
}

public struct IFShadowStyle {
    public var color: IFColorStyle
    public var radius: CGFloat
    public var offset: CGSize
    public var opacity: Float
    
    public func autoAdapt(_ adapt: Bool) -> IFShadowStyle {
        var style = self
        style.color = color.autoAdapt(adapt)
        return style
    }
    
    public func adapt(color: Color? = nil, opacity: Float? = nil, offset: CGSize? = nil, radius: CGFloat? = nil) -> IFShadowStyle {
        var style = self
        if let col = color {
            style.color = style.color.adapt(colorHex: col)
        }
        if let opa = opacity {
            style.opacity = opa
        }
        if let off = offset {
            style.offset = off
        }
        if let rad = radius {
            style.radius = rad
        }
        return style
    }
    
    /// 常用
    public static let common: IFShadowStyle = IFShadowStyle(color: IFColorStyle.common.adapt(colorHex: .blackShadow), radius: IFShadowRadius.middle, offset: IFShadowOffset.toBottom, opacity: IFOpacity.shadowBlack)
    /// 黑色
    public static let shadowBlack: IFShadowStyle = common
    /// 金色
    public static let shadowGolden: IFShadowStyle = common.adapt(color: .goldenShadow, opacity: IFOpacity.shadowGolden)
}


public struct IFLayerStyle {
    public var masksToBounds: Bool?
    public var cornerRadius: CGFloat? {
        return borderStyle?.radius
    }
    var borderStyle: IFBorderStyle?
    var shadowStyle: IFShadowStyle?
    
    public func autoAdapt(_ adapt: Bool) -> IFLayerStyle {
        var style = self
        style.borderStyle = borderStyle?.autoAdapt(adapt)
        style.shadowStyle = shadowStyle?.autoAdapt(adapt)
        return style
    }
    
    public func adapt(shadow: IFShadowStyle?) -> IFLayerStyle {
        var style = self
        style.shadowStyle = shadow
        return style
    }
    
    public func adapt(cornerRadius: CGFloat? = nil, masksToBounds: Bool? = nil) -> IFLayerStyle {
        var style = self
        if let corner = cornerRadius {
            style.borderStyle = style.borderStyle?.adapt(radius: corner) ?? IFBorderStyle.common.adapt(radius: corner)
        }
        if let mskb = masksToBounds {
            style.masksToBounds = mskb
        }
        return style
    }
    /// 常用
    public static let common: IFLayerStyle = IFLayerStyle(masksToBounds: true, borderStyle: IFBorderStyle.common, shadowStyle: nil)
    /// 按钮+阴影
    public static let button: IFLayerStyle = IFLayerStyle(masksToBounds: nil, borderStyle: IFBorderStyle.common, shadowStyle: IFShadowStyle.common)
    /// 阴影 - 黑
    public static let shadow: IFLayerStyle = IFLayerStyle(masksToBounds: nil, borderStyle: nil, shadowStyle: IFShadowStyle.shadowBlack)
    /// 阴影 - 金
    public static let shadowGolden: IFLayerStyle = IFLayerStyle(masksToBounds: nil, borderStyle: nil, shadowStyle: IFShadowStyle.shadowGolden)
}

public struct IFViewStyle {
    typealias PYAdaptStyle = IFViewStyle
    // readonly
    public var cornerRadius: CGFloat {
        return layerStyle?.cornerRadius ?? 0
    }
    public var maskToBounds: Bool {
        return layerStyle?.masksToBounds ?? false
    }
    
    public var backgroundColor: IFColorStyle?
    public var tintColor: IFColorStyle?
    public var layerStyle: IFLayerStyle?
    public var clipToBounds: Bool?
    public var opacity: Float = IFOpacity.full
    
    public func autoAdapt(_ adapt: Bool) -> IFViewStyle {
        var style = self
        style.backgroundColor = backgroundColor?.autoAdapt(adapt)
        style.tintColor = tintColor?.autoAdapt(adapt)
        style.layerStyle = layerStyle?.autoAdapt(adapt)
        return style
    }
    
    public func adapt(shadow: IFShadowStyle?) -> IFViewStyle {
        var style = self
        style.layerStyle = style.layerStyle?.adapt(shadow: shadow) ?? IFLayerStyle(masksToBounds: nil, borderStyle: nil, shadowStyle: shadow)
        return style
    }
    
    public func adapt(backgroundColor: IFColorStyle? = nil, cornerRadius: CGFloat? = nil, masksToBounds: Bool? = nil, clipToBounds: Bool? = nil, opacity: Float? = nil) -> IFViewStyle {
        var style = self
        if let bkg = backgroundColor {
            style.backgroundColor = bkg
        }
        if let opac = opacity {
            style.opacity = opac
        }
        if let clip = clipToBounds {
            style.clipToBounds = clip
        }
        if cornerRadius != nil || masksToBounds != nil {
            style.layerStyle = style.layerStyle?.adapt(cornerRadius: cornerRadius, masksToBounds: masksToBounds) ?? IFLayerStyle.common.adapt(cornerRadius: cornerRadius, masksToBounds: masksToBounds)
        }
        return style
    }
}

extension IFViewStyle {
    /// 错误
    public static let error: IFViewStyle = IFViewStyle(backgroundColor: .error)
    // MARK: - 适应暗黑
    /// 常用
    public static let common: IFViewStyle = IFViewStyle(backgroundColor: .white).autoAdapt(true)
    /// 白色文字
    public static let white: IFViewStyle = IFViewStyle(backgroundColor: .white).autoAdapt(true)
    /// 黑色背景
    public static let black: IFViewStyle = IFViewStyle(backgroundColor: .black).autoAdapt(true)
    /// 白色列表页面背景
    public static let whiteListVC: IFViewStyle = IFViewStyle(backgroundColor: IFColorStyle(colorHex: .whiteListVC)).autoAdapt(true)
    /// 列表页面背景
    public static let whiteListCell: IFViewStyle = IFViewStyle(backgroundColor: IFColorStyle(colorHex: .whiteSectionBg)).autoAdapt(true)
    // MARK: - 不自动适应暗黑
    /// 黑色阴影
    public static let shadow: IFViewStyle = IFViewStyle(layerStyle: IFLayerStyle.shadow)
    /// 黑色阴影
    public static let shadowGolden: IFViewStyle = IFViewStyle(layerStyle: IFLayerStyle.shadowGolden)
    /// 按钮常用，黑色渐变，作用shadow和按钮背景图
    public static let button: IFViewStyle = IFViewStyle(backgroundColor: .blackGradient, layerStyle: IFLayerStyle.button)
    /// 按钮金色渐变常用，只作用shadow
    public static let buttonGolded: IFViewStyle = IFViewStyle(backgroundColor: .goldenGradient,
                                                              layerStyle: IFLayerStyle.button.adapt(shadow: IFShadowStyle.shadowGolden)).autoAdapt(true)
}
extension UIButton: IFButtonStyleDelegate {
    public typealias PYStyle = IFButtonStyle
    
    public func setupStyle(style: PYStyle) {
        setupStyle(style: style, state: .normal)
    }
    /// 注意，在扩展情况下不支持渐变色，因为layerout为完成，无法确认按钮大小，渐变色会出问题；请使用GradientButton，或者使用IFButton
    public func setupStyle(style: PYStyle, state: UIControl.State) {
        titleLabel?.font = style.textStyle.fontStyle.font
        if state == .normal {
            // TODO: - 补充不同状态下的按钮样式设置
            // 如果有shadow，需要根据高度适配阴影参数
            if bounds != .zero,
               let shadow = style.viewStyle.layerStyle?.shadowStyle {
                let ratio =  bounds.height / 52.0
                let size = CGSize(width: shadow.offset.width, height: shadow.offset.height * ratio)
                let shadowStyle = style.viewStyle.adapt(shadow: shadow.adapt(offset: size, radius: shadow.radius * ratio))
                setupStyle(style: shadowStyle)
            } else {
                setupStyle(style: style.viewStyle)
            }
            var textColorStyle = style.textStyle.colorStyle
            setTitleColor(textColorStyle.color, for: state)
            if !style.applyStyleByState {
                textColorStyle.opacity = IFOpacity.highlighted
                setTitleColor(textColorStyle.color, for: .highlighted)
                textColorStyle.opacity = IFOpacity.disabled
                setTitleColor(textColorStyle.color, for: .disabled)
            }
            
            var imgLayer: CALayer?
            if bounds != .zero, let colors = style.viewStyle.backgroundColor?.colorGradient {
                let gradientLayer: CAGradientLayer = CAGradientLayer.init()
                gradientLayer.frame = bounds
                gradientLayer.cornerRadius = style.viewStyle.layerStyle?.cornerRadius ?? IFCornerRadius.small
                gradientLayer.colors = colors.map({ $0.getUIColor().cgColor })
                gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
                imgLayer = gradientLayer
            } else if let adaptColor = style.viewStyle.backgroundColor?.color {
                // 纯色填充不用关心大小，可以利用cornerRadius + stretch
                let colorLayer = CALayer()
                colorLayer.frame = bounds
                if let layerStyle = style.viewStyle.layerStyle {
                    colorLayer.cornerRadius = layerStyle.cornerRadius ?? IFCornerRadius.small
                }
                colorLayer.backgroundColor = adaptColor.cgColor
                imgLayer = colorLayer
            } else {
                assert(false, "未设置背景")
            }
            // 此处按钮可能没有layout完成，大小为zero
            if let lay = imgLayer {
                setBackgroundImage(UIImage.imageFrom(layer: lay), for: .normal)
                if !style.applyStyleByState {
                    lay.opacity = IFOpacity.highlighted
                    setBackgroundImage(UIImage.imageFrom(layer: lay), for: .highlighted)
                    lay.opacity = IFOpacity.disabled
                    setBackgroundImage(UIImage.imageFrom(layer: lay), for: .disabled)
                }
            }
        }
    }
    
    private func adaptStyleWithNormal(style: PYStyle) {
        
    }
    
    public func setupStyle(config: [IFUserInterfaceStyle: PYStyle]) {
        if let style = config[IFThemeManager.currentUIStyle()] {
            setupStyle(style: style)
        } else {
            setupStyle(style: PYStyle.error)
        }
    }
    
    /// 按钮状态样式配置
    /// - Parameters:
    ///   - config: 主题配置
    ///   - state: 按钮状态
    public func setupStyle(config: [IFUserInterfaceStyle: PYStyle], state: UIControl.State) {
        if let style = config[IFThemeManager.currentUIStyle()] {
            setupStyle(style: style, state: state)
        } else {
            setupStyle(style: PYStyle.error)
        }
    }
}


public protocol IFButtonStyleDelegate: IFTextStyleDelegate {
    func setupStyle(config: [IFUserInterfaceStyle: IFButtonStyle], state: UIControl.State)
}

// MARK: - UI控件样式
public protocol PYStyleDelegate {
    associatedtype PYStyle
    
    /// 一次性设置样式，不会去适配风格
    /// - Parameter style: 样式
    func setupStyle(style: PYStyle)
    
    /// 设置样式配置表
    /// - Parameter config: 配置信息，内部会根据当前系统风格进行适配
    func setupStyle(config: [IFUserInterfaceStyle: PYStyle])
}

// MARK: - 文本样式
public protocol IFTextStyleDelegate: PYStyleDelegate {
    //    /// 一次性设置样式，不会去适配风格
    //    /// - Parameter style: 文字样式
    //    func setupStyle(style: IFTextStyle)
    //
    //    /// 设置样式配置表
    //    /// - Parameter config: 配置信息，内部会根据当前系统风格进行适配
    //    func setupStyle(config: [IFUserInterfaceStyle: IFTextStyle])
    //
    //    /// 设置样式
    //    /// - Parameters:
    //    ///   - style: 文字样式
    //    ///   - autoAdapt: 是否自动根据样式中可适配的属性进行风格适配
    //    func setupStyle(style: IFTextStyle, autoAdapt: Bool)
}


extension UIView: PYStyleDelegate {
    public typealias PYStyle = IFViewStyle
    
    public func setupStyle(style: IFViewStyle) {
        if let bgc = style.backgroundColor, !isKind(of: UIButton.self) {
            backgroundColor = bgc.color
            /// gradient无法支持，因为layout完成情况不确定
        }
        if let tintc = style.tintColor {
            tintColor = tintc.color
        }
        if let layerStyle = style.layerStyle {
            if let cornerR = layerStyle.cornerRadius {
                layer.cornerRadius = cornerR
            }
            if let maskBounds = layerStyle.masksToBounds {
                layer.masksToBounds = maskBounds
            }
            if let borderStyle = layerStyle.borderStyle {
                if let bcor = borderStyle.color {
                    layer.borderColor = bcor.color.cgColor
                }
                layer.borderWidth = borderStyle.width
            }
            if let shadowStyle = layerStyle.shadowStyle {
                self.layer.shadowColor = shadowStyle.color.color.cgColor
                self.layer.shadowOffset = shadowStyle.offset
                self.layer.shadowRadius = shadowStyle.radius
                self.layer.shadowOpacity = Float(shadowStyle.opacity)
                if bounds != .zero {
                    self.layer.shadowPath = UIBezierPath(roundedRect: bounds.offsetBy(dx: shadowStyle.offset.width,
                                                                                      dy: shadowStyle.offset.height),
                                                         cornerRadius: layer.cornerRadius).cgPath
                }
            }
        }
        if let clipBounds = style.clipToBounds {
            clipsToBounds = clipBounds
        }
    }
    
    public func setupStyle(config: [IFUserInterfaceStyle: IFViewStyle]) {
        if let style = config[IFThemeManager.currentUIStyle()] {
            setupStyle(style: style)
        } else {
            setupStyle(style: IFViewStyle.error)
        }
    }
    
    public func registerTheme() {
        guard let vistor = self as? IFThemeDelegate else {
            precondition(false, "请先实现IFThemeDelegate，将主题风格控件适配到setupTheme方法中")
            return
        }
        IFThemeManager.registerVisitor(vistor: vistor)
    }
}
