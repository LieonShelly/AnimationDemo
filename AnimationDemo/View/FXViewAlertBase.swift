//
//  FXViewAlertBase.swift
//  PgImageProEditUISDK
//
//  Created by Bob Lee on 2019/6/4.
//  这个文件的代码的写得很差，拷贝的别人的，仅仅只是为了和工程里面的配置一致，便于高效调试UI

import UIKit

class FXAlertWindow: UIWindow {}

open class FXViewAlertBase: UIViewController {
    public var isSetupUIWhenDisplay: Bool = true
    /// 是否根据屏幕宽度来适配弹框宽度
    public var shouldAdaptWidth: Bool = false
    /** 弹框的真实宽度 */
    open var widthAlert: CGFloat = CGFloat(290).adaptedValue()
    open var heightOfAlert: CGFloat = CGFloat(504).adaptedValue()
    /** 弹框内容控件最大宽度 */
    public var widthSubViewMax: CGFloat {
        return widthAlert - paddingOut*2
    }
    /// 默认图标大小
    public var heightIcon: CGFloat = 48.0
    /// 图标距离顶部背景距离
    public var iconTop: CGFloat = CGFloat(20).adaptedValue()
    /// 标题距离图标底部距离
    public var titleTopToIcon: CGFloat = CGFloat(12).adaptedValue()
    /// 内容距离顶部距离
    public var contentTopToBg: CGFloat = CGFloat(36).adaptedValue()
    /// 内容距离图标底部距离（当其上面是图片情况下）
    public var contentTopToIcon: CGFloat = CGFloat(12).adaptedValue()
    /// 内容距离标题底部距离（当其上面是标题情况下）
    public var contentTopToTitle: CGFloat = CGFloat(10).adaptedValue()
    /** 内容相对弹框背景的边缘距离 */
    public let paddingOut: CGFloat = CGFloat(25).adaptedValue()
    /** 关闭按钮相对背景的边距 */
    public let marginBtnClose: CGFloat = CGFloat(12).adaptedValue()
    /** 文本间垂直方向的间距 */
    public let marginTxt: CGFloat = CGFloat(12).adaptedValue()
    /** 大按钮与其他内容的距离，左右上下 */
    public let marginBtn: CGFloat = CGFloat(30).adaptedValue()
    /// 按钮之间的间隔
    public let marginBtnInner: CGFloat = CGFloat(14).adaptedValue()
    /** 标题字体 */
    public var fontTitle: UIFont = IFTextStyle.labAlertTitle.font
    /** 内容字体 */
    public var fontContent: UIFont = IFTextStyle.labAlertDesc.font
    /** 输入字体 */
    public var fontInput: UIFont = UIFont.customFont(ofSize: 16)
    /** 按钮高度 */
    public let heightBtn: CGFloat = CGFloat(50).adaptedValue()
    /** 关闭按钮高度 */
    public let heightBtnClose: CGFloat = CGFloat(34).adaptedValue()
    /** 标题最小高度，用于动态计算 */
    public var heightTitleMin: CGFloat = CGFloat(30).adaptedValue()
    /** 内容最小高度，用于动态计算 */
    public var heightContentMin: CGFloat = CGFloat(20).adaptedValue()
    /** 输入框高度 */
    public var heightInput: CGFloat = CGFloat(36).adaptedValue()
    /** 按钮圆角 */
    public var radiusBtn: CGFloat = CGFloat(2).adaptedValue()
    /** 背景圆角 */
    public var radiusBg: CGFloat = CGFloat(2).adaptedValue()
    /** 按钮字体 */
    public var fontBtn: UIFont = UIFont.customFont(ofSize: 16, isBold: true)
    /** 标题颜色 */
    public var colorTitle: UIColor? = Color.black.getUIColor()
    /** 内容颜色 */
    public var colorContent: UIColor? = Color.grayText.getUIColor()
    /** 是否需要虚化背景 */
    public var shouldDispBlurBg: Bool = false
    /// 当前弹框的背景色，shouldDispBlurBg = true此值无效
    open var backgroundColor: UIColor? = UIColor(white: 0, alpha: CGFloat(IFOpacity.high))
    /** 需要自己计算到的高度 */
    open var heightAlert: CGFloat = 0
    
    /** 承载弹框内容的背景view，请将自己的UI布局放到此view上 */
    public lazy var viewAlertBg: UIView = {
        let temp = UIView.init()
        temp.backgroundColor = UIColor.white
        return temp
    }()
    private lazy var btnClose: UIButton = {
        var btn = UIButton.init()
        btn.setImage(UIImage(named: "ic_alert_close"), for: .normal)
        btn.addTarget(self, action: #selector(btnCloseClicked), for: .touchUpInside)
        viewAlertBg.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(marginBtnClose)
            make.right.equalTo(-marginBtnClose)
            make.width.height.equalTo(heightBtnClose)
        }
        return btn
    }()
    fileprivate var alertBlurBg: UIImageView? {
        return FXViewAlertBase.alertWindow.viewWithTag(1909002) as? UIImageView
    }
    /// 是否在右上角展示关闭按钮，默认不展示
    public var shouldDisplayCloseButton: Bool = false
    /// 是否点击背景(排除弹框内容外的区域)自动关闭（cancel）；仅支持采用viewAlertBg承载的弹框
    public var autoDismissWhileBackgroundClicked: Bool = false
    
    /// 即将展示弹框
    public private(set) var willShowClosure: (() -> Void)?
    /// 已经展示弹框
    public private(set) var didShowClosure: (() -> Void)?
    /// 即将移除弹框
    public private(set) var willDismissClosure: (() -> Void)?
    /// 已移除弹框
    public private(set) var didDismissClosure: ((Any?) -> Void)?
    
    /** 当前展示的弹框 */
    public static var alertCache: FXViewAlertBase?
    fileprivate static var alertQueue: [FXViewAlertBase] = []
    /// 是否正在弹出，此时不能中断，后来弹框排队
    fileprivate static var isAnimation: Bool = false
    static var alertWindow: FXAlertWindow = {
        let win = FXAlertWindow.init()
        win.backgroundColor = .clear
        win.tag = 1999999
        //        win.windowLevel = UIWindowLevelAlert
        
        let imgV = UIImageView.init()
        imgV.tag = 1909002
        imgV.alpha = 0
        win.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalToSuperview()
        }
        
        return win
    }()
    
    fileprivate weak static var lastWindow: UIWindow?
    
    deinit {
        print("alert dealloc")
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    final override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     统一UI创建方法
     统一使用widthAlert
     */
    open func setupUI() {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapBackground(_:))))
    }
    
    /// 统一处理数据方法
    open func setupData() {
        
    }
    
    /// 设置背景的阴影
    internal func setupShadowBg(_ contentView: UIView?) {
        guard let content = contentView else { return }
        // 自己的shadow
        content.layer.cornerRadius = radiusBg
        content.layer.shadowColor = UIColor.gray.cgColor
        content.layer.shadowOffset = CGSize(width: 0.0, height: CGFloat(5).adaptedValue())
        content.layer.shadowOpacity = 0.25
        content.layer.borderColor = UIColor.gray.withAlphaComponent(0.15).cgColor
        content.layer.borderWidth = CGFloat(0.5).adaptedValue()
//        content.layer.masksToBounds = true
        content.layer.shadowPath = UIBezierPath(roundedRect: content.bounds.offsetBy(dx: 0, dy: 5), cornerRadius: radiusBg).cgPath
    }
    
    /// 采用VC.view展示，且不关心回调
    @available(*, deprecated, message: "已经不再维护，请使用 display(willShow:didShow:willDismiss:didDismiss:)")
    open func show() {
        show(heightAlert, dismiss: nil)
    }
    
    /**
     展示弹框内容
     1.标准弹框，如果内容放置到viewAlertBg上，请勿设置viewAlertBg的约束关系
     2.自定义尺寸弹框，如果内容放置到VC.view上，请自己设置内容约束关系
     
     - Parameters:
     - heightOfAlert: =0时自己控制内容布局；>0时内容需要放置到viewAlertBg上弹框内容高度（包括上下边距，按照设计图规范处理），show逻辑不会修改此值
     - dismiss: 关闭弹框回调
     
     - Authors: Bob
     - Date: 2019
     */
    @available(*, deprecated, message: "已经不再维护，请使用 display(willShow:didShow:willDismiss:didDismiss:)")
    open func show(_ dismiss: ((Any?) -> Void)?) {
        show(heightAlert, dismiss: dismiss)
    }
    
    @available(*, deprecated, message: "已经不再维护，请使用 display(willShow:didShow:willDismiss:didDismiss:)")
    open func show(_ heightOfAlert: CGFloat = 0, dismiss: ((Any?) -> Void)?) {
        show(heightOfAlert, false, dismiss: dismiss)
    }
    
    private func show(_ heightOfAlert: CGFloat = 0, _ adaptWidth: Bool = false, dismiss: ((Any?) -> Void)?) {
        didDismissClosure = dismiss
        let win = FXViewAlertBase.alertWindow
        let lastAlert = FXViewAlertBase.alertQueue.last
        if lastAlert == self {
            // 同一个弹框对象连续弹很奇葩，不予处理
            return
        }
        
        heightAlert = heightOfAlert
        if heightOfAlert > 0 {
            let vbg = viewAlertBg
            if vbg.superview == nil {
                view.addSubview(vbg)
            }
            viewAlertBg.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                if adaptWidth {
                    make.width.equalTo(widthAlert.adaptedActualWidthRatioValue())
                } else {
                    make.width.equalTo(widthAlert)
                }
                
                if heightOfAlert > 1 {
                    make.height.equalTo(heightOfAlert)
                } else {
                    make.height.greaterThanOrEqualTo(100)
                }
            })
            // 强制布局计算出弹框大小
            view.setNeedsLayout()
            setupShadowBg(viewAlertBg)
            if shouldDisplayCloseButton {
                _ = btnClose
            }
        }
        
        FXViewAlertBase.alertQueue.append(self)
        if FXViewAlertBase.isAnimation {
            return
        }
        FXViewAlertBase.alertCache = self
        FXViewAlertBase.isAnimation = true
        if lastAlert == nil {
            // 控制底层渲染逻辑
            FXViewAlertBase.lastWindow = UIApplication.shared.keyWindow
            win.rootViewController = self
            win.isHidden = false
            win.isUserInteractionEnabled = true
            if !win.isKeyWindow {
                win.makeKeyAndVisible()
            }
            showBlurBg(self, isFirst: true)
            showAnimation(self, isDismiss: false) { [weak self] in
                if let weakself = self {
                    if FXViewAlertBase.alertQueue.last != weakself {
                        weakself.showNext(weakself) {
                            FXViewAlertBase.isAnimation = false
                        }
                    } else {
                        FXViewAlertBase.isAnimation = false
                    }
                } else {
                    FXViewAlertBase.isAnimation = false
                }
            }
        } else {
            showNext(lastAlert!) {
                FXViewAlertBase.isAnimation = false
            }
        }
    }
    
    private func showNext(_ current: FXViewAlertBase?, callback: @escaping () -> Void) {
        let win = FXViewAlertBase.alertWindow
        
        func showNew() {
            if let other = FXViewAlertBase.alertQueue.last {
                win.rootViewController = other
                current?.view.alpha = 1 // 有的弹框自己搞了个单例导致再次弹出就看不见的问题
                
                self.showBlurBg(other)
                self.showAnimation(other, isDismiss: false) {
                    FXViewAlertBase.alertCache = other
                    callback()
                }
            }
        }
        
        if let cur = current {
            showAnimation(cur, isDismiss: true) {
                showNew()
            }
        } else {
            showNew()
        }
    }
    
    private func showBlurBg(_ vc: FXViewAlertBase, isFirst: Bool = false) {
        guard vc.shouldDispBlurBg else {
            alertBlurBg?.alpha = 0
            if backgroundColor != nil || alertBlurBg?.backgroundColor != nil {
                UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: {
                    self.alertBlurBg?.alpha = 1.0
                    self.alertBlurBg?.backgroundColor = self.backgroundColor
                })
            } else {
                alertBlurBg?.backgroundColor = nil
            }
            return
        }
        if isFirst, let lastWin = FXViewAlertBase.lastWindow {
            alertBlurBg?.alpha = 0
            // 增加延迟是因为在弹框时当前window内容帧可能还未刷新导致背景blur不是模板图像
//            DispatchQueue.main.after(interval: 0.005) {
                let img = UIView.screenshot(lastWin)
                let blurImg = img?.imageBlured(radius: 10, size: lastWin.bounds.size, contentModel: .scaleAspectFill, scale: 1.0, blend: [UIColor.black.cgColor], blendOpacity: 0.35, opaque: true)
                self.alertBlurBg?.image = blurImg
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               options: [.transitionCrossDissolve],
                               animations: {
                                self.alertBlurBg?.alpha = 1
                               }, completion: nil)
//            }
        } else if alertBlurBg?.alpha == 0 {
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: {
                self.alertBlurBg?.alpha = 1
            })
        }
    }
    
    private func showAnimation(_ target: FXViewAlertBase, isDismiss: Bool, callback: @escaping () -> Void) {
        if isDismiss {
            willDismissClosure?()
            if !dismissWithCustomAnimation(complete: {
                callback()
            }) {
                UIView.animate(withDuration: 0.7,
                               delay: 0,
                               options: [.curveEaseInOut, .transitionCrossDissolve],
                               animations: {
                                target.view.center.y = target.view.frame.maxY * 1.5
                }, completion: { _ in
                    callback()
                })
            }
        } else {
            willShowClosure?()
            var viewTarget: UIView? = target.view.subviews.last
            if viewTarget?.bounds == CGRect.zero {
                for sub in target.view.subviews {
                    if sub.bounds != target.view.bounds && sub.bounds != CGRect.zero {
                        viewTarget = sub
                        break
                    }
                }
            }
            
            // 相对布局情况会导致无法获得内容view的大小
            var topOffset = viewTarget?.frame.minY ?? 0
            if topOffset <= 0 {
                topOffset = 100 // target.view.bounds.height/2
            }
            
            let trans = CGAffineTransform.init(translationX: 0, y: -topOffset)  //CGAffineTransform.init(scaleX: 0.7, y: 0.7) // CGAffineTransform.init(rotationAngle: -10/180 * CGFloat.pi)
            target.view.transform = trans
            target.view.alpha = 0
            if !showWithCustomAnimation(complete: {
                callback()
                target.didShowClosure?()
            }) {
                UIView.animate(withDuration: 0.7,
                               delay: 0.15,
                               usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3,
                               options: [.curveEaseInOut, .transitionCrossDissolve],
                               animations: {
                                target.view.transform = CGAffineTransform.identity
                                target.view.alpha = 1
                }) { (finished) in
                    callback()
                    target.didShowClosure?()
                }
            }
        }
    }
    
    /// 需要自己触发回调通知，如果需要回调
    open func dismiss() {
        dismiss(false)
    }
    
    /// 消失回调数据
    open func dismiss(_ result: Any?) {
        dismiss(true, result: result)
    }
    
    /// 选择是否触发回调，如果需要回调
    open func dismiss(_ shouldCallback: Bool, result: Any?) {
        FXViewAlertBase.isAnimation = true
        if FXViewAlertBase.alertQueue.count > 1 {
            if let idx = FXViewAlertBase.alertQueue.firstIndex(of: self) {
                FXViewAlertBase.alertQueue.remove(at: idx)
            }
            
            showNext(self) {
                FXViewAlertBase.isAnimation = false
            }
            
            if shouldCallback, let callback = didDismissClosure {
                callback(result)
            }
            
        } else {
            showAnimation(self, isDismiss: true) { [weak self] in
                guard let strongSelf = self else { return }
                if let idx = FXViewAlertBase.alertQueue.firstIndex(of: strongSelf) {
                    FXViewAlertBase.alertQueue.remove(at: idx)
                }
                
                // 可能在动画过程中新增了弹框
                if FXViewAlertBase.alertQueue.count > 0 {
                    strongSelf.showNext(nil, callback: { })
                    if shouldCallback, let callback = strongSelf.didDismissClosure {
                        callback(result)
                    }
                    return
                }
                
                strongSelf.view.alpha = 1
                FXViewAlertBase.lastWindow?.makeKeyAndVisible()
                
                FXViewAlertBase.isAnimation = false
                
                FXViewAlertBase.alertWindow.rootViewController = nil
                FXViewAlertBase.alertWindow.isUserInteractionEnabled = false
                FXViewAlertBase.alertWindow.isHidden = true // bob 由于互动教程还有一层window，在各个window切换成keyWindow后，UIApplication的windows层级发生变化，导致编辑页面所在的widnow不响应
                if shouldCallback, let callback = strongSelf.didDismissClosure {
                    callback(result)
                }
                if FXViewAlertBase.alertCache == strongSelf {
                    FXViewAlertBase.alertCache = nil
                }
            }
            
            UIView.animate(withDuration: 0.7,
                           delay: 0,
                           options: [.curveEaseInOut, .transitionCrossDissolve],
                           animations: {
                            self.alertBlurBg?.alpha = 0
            }, completion: nil)
        }
    }
    
    /// 获取按钮背景图片
    open func getImageForButton(_ width:CGFloat) -> UIImage? {
        let img = UIImage.imageWithHexColors(["#7ad3ff", "#ff41d3"], gType: .leftToRight, size: CGSize.init(width: width, height: heightBtn))
        return img
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    ///
    /// 展示弹框
    /// bob 2019-12-23 添加新的展示方法
    /// - Note:
    ///     * 没有特殊情况下，外界不用手动调用dismiss方法，由弹框类自己触发
    ///     * 弹框背景自适应屏幕宽度
    ///     * 弹框背景统一采用viewAlertBg
    ///
    /// - Parameters:
    ///     - willShow: 即将展示到屏幕
    ///     - didShow: 已经展示到屏幕
    ///     - willDismiss: 即将移除弹框
    ///     - didDismiss: 已经移除弹框
    public final func display(willShow beforeAnimation:(() -> Void)? = nil,
                              didShow animationEnd:(() -> Void)? = nil,
                              willDismiss beforeRemoveAnimation:(() -> Void)? = nil,
                              didDismiss afterRemoved:((Any) -> Void)? = nil) {
        willShowClosure = beforeAnimation
        didShowClosure = animationEnd
        willDismissClosure = beforeRemoveAnimation
        didDismissClosure = afterRemoved
        // 触发创建UI
        if isSetupUIWhenDisplay {
            setupUI()
            show(1, shouldAdaptWidth, dismiss: afterRemoved)
        } else {
            show(0, shouldAdaptWidth, dismiss: afterRemoved)
        }
        
    }
    
    /// 子类重写自定义弹框出现动效
    open func showWithCustomAnimation(complete: @escaping () -> Void) -> Bool {
        return false
    }
    /// 子类重写自定义弹框消失动效
    open func dismissWithCustomAnimation(complete: @escaping () -> Void) -> Bool {
        return false
    }
}

extension FXViewAlertBase {
    
    @objc private func btnCloseClicked() {
        dismiss()
    }
    
    @objc private func handleTapBackground(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized, autoDismissWhileBackgroundClicked {
            let loc = sender.location(in: view)
            if !viewAlertBg.frame.contains(loc) {
                dismiss()
            }
        }
    }
    
}

extension FXViewAlertBase {
    public static func dismiss(_ alert: AnyClass? = nil) {
        if let aType = alert, let alt = alertQueue.first(where: { $0.isMember(of: aType) }) {
            alertQueue.removeAll(where: { $0.isMember(of: aType) })
            if alt == alertCache {
                alt.dismiss()
            }
        } else {
            alertQueue.removeAll()
            alertCache?.dismiss()
        }
    }
}

public class FXViewAlertButtion {
    public var title: String
    public var isCancel: Bool = false
    public var gradient: [UIColor]?
    public var autoDismissWhileClicked: Bool = true
    public var clickClosure: ((_ alert: FXViewAlertBase?) -> Void)?
    
    public init(title: String, gradient: [UIColor]? = nil, autoDismissWhileClicked: Bool = true, isCancel: Bool = false, clickClosure: ((_ alert: FXViewAlertBase?) -> Void)? = nil) {
        self.title = title
        self.gradient = gradient
        self.autoDismissWhileClicked = autoDismissWhileClicked
        self.isCancel = isCancel
        self.clickClosure = clickClosure
    }
}

public struct IFTextStyle {
    typealias PYAdaptStyle = IFTextStyle
    
    // readonly
    public var color: UIColor {
        return colorStyle.color
    }
    public var fontSize: CGFloat {
        return fontStyle.size
    }
    public var weight: IFFontWeight {
        return fontStyle.weight
    }
    public var opacity: Float {
        return colorStyle.opacity
    }
    public var font: UIFont {
        return fontStyle.font
    }
    var fontStyle: IFFontStyle
    var colorStyle: IFColorStyle
    
    public init(fontStyle: IFFontStyle, colorStyle: IFColorStyle) {
        self.fontStyle = fontStyle
        self.colorStyle = colorStyle
    }
    
    /// 自适应风格，可风格化的属性会被控制
    /// - Returns: 调整后样式
    public func autoAdapt(_ adapt: Bool) -> IFTextStyle {
        var style = self
        style.colorStyle = colorStyle.autoAdapt(adapt)
        return style
    }
    
    public func adapt(family: IFFontFamily? = nil, weight: IFFontWeight? = nil, size: CGFloat? = nil, color: Color? = nil, opacity: Float? = nil) -> IFTextStyle {
        var style = self
        if weight != nil || size != nil || family != nil {
            style.fontStyle = fontStyle.adapt(family: family, weight: weight, size: size)
        }
        if color != nil || opacity != nil {
            style.colorStyle = colorStyle.adapt(colorHex: color, opacity: opacity)
        }
        return style
    }
}

// MARK: - 常用定义，不自动适配暗黑
extension IFTextStyle {
    /// 错误
    public static let error = common.adapt(color: .red, opacity: IFOpacity.medium)
    // MARK: - 通用部分主要为label服务
    /// 通用-black
    public static let common = black
    /// 普通黑文字
    public static let black = IFTextStyle(fontStyle: IFFontStyle(family: .pingFangSC,
                                                                 weight: .regular,
                                                                 face: .normal,
                                                                 size: IFFontSize.middle16),
                                          colorStyle: IFColorStyle(colorHex: .black,
                                                                   opacity: IFOpacity.full))
    /// 普通白文字
    public static let white = black.adapt(color: .white)
    /// 金色
    public static let golden = black.adapt(color: .golden)
    /// UILabel通用
    public static let labCommon = black
    
    // MARK: - 弹框
    
    /// 弹框标题
    public static let labAlertTitle = black.adapt(weight: .semibold, size: IFFontSize.large18)
    /// 弹框副标题
    public static let labAlertDesc = black.adapt(size: 15, color: .grayText)
    /// 弹框副标题 - 没有主标题
    public static let labAlertDescNoTitle = black.adapt(size: 15)
    /// 弹框副标题 - 没有主标题、没有图标
    public static let labAlertDescNoTitleNoImage = black.adapt(weight: .semibold)
    /// 普通按钮
    public static let btnAlertCommon = black
    /// 按钮取消
    public static let btnAlertCancel = btnAlertCommon.adapt(color: .grayText)
    
    // MARK: - 自动适配部分
    public static let vcBg = black.adapt(color: .white).autoAdapt(true)
    /// 默认黑色
    public static let labelBlack = black.autoAdapt(true)
    /// 默认白色
    public static let labelWhite = white.autoAdapt(true)
    /// 默认灰色
    public static let labelGray = black.adapt(color: .grayText).autoAdapt(true)
    /// 默认导航
    public static let labelNaviTitle = black.adapt(weight: .semibold, size: IFFontSize.middle16).autoAdapt(true)
}




// UIUserInterfaceStyle iOS 12以上，此处自己维护一套支持到iOS 11控制
@objc
public enum IFUserInterfaceStyle: Int {
    /// 不确定就是没有设置过，默认采用浅色
    case unspecified = 0
    /// 固定浅色
    case light = 1
    /// 固定深色
    case dark = 2
}

/// 基础选项 - 透明度
public enum IFOpacity {
    /// 不可见
    public static let none: Float     = 0.0
    /// 0.05, 0.01系统会认为不可见
    public static let veryLow: Float  = 0.05
    /// 0.20
    public static let low: Float      = 0.20
    /// 0.30
    public static let low03: Float      = 0.30
    /// 0.50
    public static let medium: Float  = 0.50
    /// 0.7 弹框、HUD、气泡等压黑背景
    public static let high: Float     = 0.7
    /// 1.0
    public static let full: Float     = 1.0
    /// 不可见
    public static let hide: Float     = none
    /// 普通正常状态
    public static let normal: Float     = full
    /// 高亮、按压、点中
    public static let highlighted: Float     = medium
    /// 不可用
    public static let disabled: Float     = medium
    /// 金色按钮阴影
    public static let shadowGolden: Float     = low03
    /// 黑色按钮阴影
    public static let shadowBlack: Float     = low
    /// 弹框、HUD、气泡等压黑背景
    public static let background: Float = high
}

/// 基础选项 - 颜色
public extension Color {
    
    /// 提供主题颜色映射值
    /// - Parameter uiStyle: 当前主题
    /// - Returns: 需要调整的颜色
    func adaptUIStyle(_ uiStyle: IFUserInterfaceStyle? = nil) -> Color {
        let uStyle = uiStyle ?? IFThemeManager.currentUIStyle()
        var cstr = self
        if uStyle == .dark, let styleColor = Color(rawValue: "\(self.rawValue)Dark") {
            cstr = styleColor
        }
        return cstr
    }
    
    /// 获取风格配色
    /// - Parameter alpha: 透明度
    /// - Returns: 颜色
    func getStyleColor(_ alpha: Float = IFOpacity.full) -> UIColor {
        return adaptUIStyle().getUIColor(alpha)
    }
}

/// 基础选项 - 字体大小
public enum IFFontSize {
    /// 26
    public static let extraLarge: CGFloat = 26.0
    /// 20，模板详情标题
    public static let large: CGFloat = 23.0
    /// 18，弹框标题、Col-Section大标题、模板列表标题、
    public static let large18: CGFloat = 18.0
    /// 16，导航标题，普通按钮文字，气泡提示，
    public static let middle16: CGFloat = 16.0
    /// 15，弹框内容
    public static let middle15: CGFloat = 15.0
    /// 14
    public static let middle14: CGFloat = 14.0
    /// 13 目录名称，
    public static let small13: CGFloat = 13.0
    /// 12 模板列表内容
    public static let small: CGFloat = 12.0
    /// 11 包名称，
    public static let small11: CGFloat = 11.0
    /// 10
    public static let extraSmall: CGFloat = 10.0
}

/// 基础选项 - 字体名，使用时采用.capitalized大写首字母
public enum IFFontFamily: String {
    /// 平方
    case pingFangSC
    /// 比较紧密
    case oswald
    /// 思源
    case sourceHanSansCN
}

/// 基础选项 - 字体粗细，使用时采用.capitalized大写首字母
public enum IFFontWeight: String {
    /// 特黑
    case heavy
    /// 粗
    case bold
    /// 中黑
    case semibold
    /// 中粗
    case medium
    /// 常规
    case regular
    /// 细
    case light
}

/// 基础选项 - 字体显示
public enum IFFontFace {
    case normal
    case italic
}

/// 基础选项 - 圆角半径大小（非圆形）
public enum IFCornerRadius {
    /// 8
    public static let large: CGFloat = 8.0
    /// 5
    public static let middle: CGFloat = 5.0
    /// 2
    public static let small: CGFloat = 2.0
    /// 0
    public static let none: CGFloat = 0.0
}

/// 基础选项 - 边框厚度
public enum IFBorderWidth {
    /// 2
    public static let thick: CGFloat = 2.0
    /// 1
    public static let normal: CGFloat = 1.0
    /// 0.5
    public static let thin: CGFloat = 0.5
    /// 0
    public static let none: CGFloat = 0.0
}

/// 基础选项 - 阴影方向
public enum IFShadowOffset {
    /// 环绕
    public static let around: CGSize = CGSize(width: 3.0, height: 0.0)
    /// 底部
    public static let toBottom: CGSize = CGSize(width: 0.0, height: 5.0)
    /// 顶部
    public static let toTop: CGSize = CGSize(width: 3.0, height: 0.0)
    /// 无
    public static let none: CGSize = CGSize(width: 0.0, height: 0.0)
}

/// 基础选项 - 阴影半径
public enum IFShadowRadius {
    /// 15
    public static let large: CGFloat = 15.0
    /// 10
    public static let middle: CGFloat = 10.0
    /// 5
    public static let small: CGFloat = 5.0
    /// 0
    public static let none: CGFloat = 0.0
}


/// color define
public enum Color: String {
    /// #ffffff ff(1.0)
    case whiteVC
    /// #131313 ff(1.0)
    case whiteVCDark
    /// #f0f0f0 ff(1.0)
    case grayImageBg
    /// #333333 ff(1.0)
    case grayImageBgDark
    /// #d7d7d7 ff(1.0)
    case grayD8D8D8
    /// #000000 ff(1.0)
    case blackShadow
    /// #282828 ff(1.0)
    case blackPanel
    /// #474747 ff(1.0)
    case blackGradientBegin
    /// #8c8a8a ff(1.0)
    case graySpan
    /// #ffffff ff(1.0)
    case whiteNaviBarBg
    /// #212121 ff(1.0)
    case whiteNaviBarBgDark
    /// #e6cfc1 ff(1.0)
    case goldenGradientEnd
    /// #d7b9a6 ff(1.0)
    case goldenGradientEndDark
    /// #eeeeee ff(1.0)
    case whiteCellHighlight
    /// #282828 ff(1.0)
    case whiteCellHighlightDark
    /// #deb69b ff(1.0)
    case goldenBackground
    /// #deb69b ff(1.0)
    case goldenFlag
    /// #fbf2ed ff(1.0)
    case yellowFlag
    /// #322e2b ff(1.0)
    case yellowFlagDark
    /// #999999 ff(1.0)
    case gray999
    /// #808080 ff(1.0)
    case gray999Dark
    /// #666666 ff(1.0)
    case gray666
    /// #f5f5f5 ff(1.0)
    case whiteListVC
    /// #131313 ff(1.0)
    case whiteListVCDark
    /// #cdcdcd ff(1.0)
    case grayImageBorder
    /// #333333 ff(1.0)
    case grayImageBorderDark
    /// #775e4a ff(1.0)
    case goldenBtnText
    /// #e4b99d ff(1.0)
    case goldenShadow
    /// #000000 ff(1.0)
    case goldenShadowDark
    /// #eacdba 3f(0.2)
    case goldenDesc
    /// #20232a ff(1.0)
    case blackBg
    /// #e9e9e9 ff(1.0)
    case grayCancelBg
    /// #fbeae0 ff(1.0)
    case goldenGradientBegin
    /// #f7e0d0 ff(1.0)
    case goldenGradientBeginDark
    /// #f6f6f6 ff(1.0)
    case whiteText
    /// #b5b6b7 ff(1.0)
    case grayText
    /// #808080 ff(1.0)
    case grayTextDark
    /// #282828 ff(1.0)
    case blackGradientEnd
    /// #ffffff ff(1.0)
    case whiteSectionBg
    /// #222222 ff(1.0)
    case whiteSectionBgDark
    /// #999999 ff(1.0)
    case blackDesc
    /// #ff0000 ff(1.0)
    case red
    /// #333333 ff(1.0)
    case black
    /// #f6f6f6 ff(1.0)
    case blackDark
    /// #e5c9b6 ff(1.0)
    case golden
    /// #eb904d ff(1.0)
    case orange
    /// #e9e9e9 ff(1.0)
    case gray
    /// #808080 ff(1.0)
    case grayDark
    /// #ffffff ff(1.0)
    case white
    /// #131313 ff(1.0)
    case whiteDark

    public func getUIColor(_ alpha: Float? = nil) -> UIColor {
        let color = customColors[self.rawValue] ?? UIColor.white
        if let alp = alpha {
            return color.withAlphaComponent(CGFloat(alp))
        } else {
            return color
        }
    }
}



public class IFThemeManager {
    private struct ThemeVistor {
        weak var vistor: IFThemeDelegate?
        var assocKey: String?
    }
    
    private static let shared: IFThemeManager = IFThemeManager()
    private var innerStyle: IFUserInterfaceStyle = .light {
        didSet {
            userInterfaceStyleChanged()
        }
    }
    /// 全局样式类型
    private(set) var uiStyle: IFUserInterfaceStyle {
        get {
            return innerStyle
        }
        set {
            if newValue != innerStyle {
                if #available(iOS 12.0, *) {
                    localTraitCollection = UITraitCollection(userInterfaceStyle: newValue == .dark ? .dark : .light)
                }
                innerStyle = newValue
            }
        }
    }
    private var vistors: [ThemeVistor] = []
    private var shouldKeepSystemStyle: Bool = true
    fileprivate var localTraitCollection: UITraitCollection?
    private init() {
        if #available(iOS 12, *) {
            let currentStyle = UIView().traitCollection.userInterfaceStyle
            uiStyle = IFUserInterfaceStyle(rawValue: currentStyle.rawValue) ?? .light
            localTraitCollection = UITraitCollection(userInterfaceStyle: uiStyle == .dark ? .dark : .light)
        }
    }
    /// 准前台后只会关心系统的样式变化；程序内部手动切换
    @objc private func handleAppEnterForground() {
        guard shouldKeepSystemStyle else { return }
        if #available(iOS 13, *) {
            let style = UITraitCollection.current.userInterfaceStyle
            if style.rawValue != uiStyle.rawValue, style != .unspecified {
                uiStyle = style == .dark ? .dark : .light
            }
        }
    }
}

private extension IFThemeManager {
    func userInterfaceStyleChanged() {
        for vistor in vistors where vistor.vistor != nil {
            if vistor.vistor?.userInterfaceStyle == nil ||
                vistor.vistor?.userInterfaceStyle == .unspecified {
                vistor.vistor?.setupTheme?()
                vistor.vistor?.didThemeChanged?(uiStyle)
            }
        }
        
        vistors.removeAll(where: { $0.vistor == nil })
    }
}

public extension IFThemeManager {
    
    /// 是否处于暗黑模式，否则浅色风格模式
    static var isDarkStyle: Bool {
        return shared.uiStyle == .dark
    }
    
    static func currentUIStyle() -> IFUserInterfaceStyle {
        return shared.uiStyle
    }
    
    static func localTraitCollection() -> UITraitCollection? {
        return shared.localTraitCollection
    }
    
    static func updateUserInterfaceStyle(_ style: IFUserInterfaceStyle) {
        shared.uiStyle = style
    }
    
    /// 主风格参考系统类型变化，默认 true
    static func shouldKeepSystemStyle(_ keep: Bool) {
        shared.shouldKeepSystemStyle = keep
    }
    
    static func registerVisitor(vistor: IFThemeDelegate) {
        guard !shared.vistors.contains(where: { $0.vistor?.isEqual(vistor) ?? false }) else {
            return
        }
        shared.vistors.append(ThemeVistor(vistor: vistor))
    }
}


/// 样式自动适配协议
protocol IFStyleAdaptDelegate {
    associatedtype PYAdaptStyle
    var autoAdaptIfneeded: Bool { get set }
    func autoAdapt(_ adapt: Bool) -> PYAdaptStyle
}

/// 字体风格定义
public struct IFFontStyle {
    var family: IFFontFamily = .pingFangSC
    var weight: IFFontWeight = .regular
    var face: IFFontFace = .normal
    var size: CGFloat = IFFontSize.middle16
    private var fontName: String {
        return "\(family.rawValue.capitalized)-\(weight.rawValue.capitalized)"
    }
    public var font: UIFont {
        return UIFont(name: fontName, size: size) ?? UIFont.customFont(fontName, ofSize: size)
    }
    
    public init(size: CGFloat, isBold: Bool) {
        self.size = size
        self.weight = isBold ? .medium : .regular
    }
    
    public init(size: CGFloat, weight: IFFontWeight = .regular) {
        self.size = size
        self.weight = weight
    }
    
    public init(family: IFFontFamily, size: CGFloat = IFFontSize.middle16) {
        self.family = family
        self.size = size
    }
    
    public init(family: IFFontFamily = .pingFangSC, weight: IFFontWeight = .regular, face: IFFontFace = .normal, size: CGFloat = IFFontSize.middle16) {
        self.family = family
        self.weight = weight
        self.face = face
        self.size = size
    }
    
    public func adapt(family: IFFontFamily? = nil, weight: IFFontWeight? = nil, face: IFFontFace? = nil, size: CGFloat? = nil) -> IFFontStyle {
        var style = self
        if let fam = family {
            style.family = fam
        }
        if let wei = weight {
            style.weight = wei
        }
        if let fac = face {
            style.face = fac
        }
        if let siz = size {
            style.size = siz
        }
        return style
    }
}

public struct IFColorStyle: IFStyleAdaptDelegate {
    typealias PYAdaptStyle = IFColorStyle
    public var autoAdaptIfneeded: Bool = false
    public var colorHex: Color = .black
    public var colorGradient: [Color]? {
        get {
            innerColorGradient?.map({ autoAdaptIfneeded ? $0.adaptUIStyle() : $0 })
        }
        set {
            innerColorGradient = newValue
        }
    }
    private var innerColorGradient: [Color]?
    public var opacity: Float = IFOpacity.full
    public var color: UIColor {
        return autoAdaptIfneeded ? colorHex.adaptUIStyle().getUIColor(opacity) : colorHex.getUIColor(opacity)
    }
    
    public init(colorHex: Color, opacity: Float = IFOpacity.full) {
        self.colorHex = colorHex
        self.opacity = opacity
    }
    public init(colors: [Color] = [.blackGradientBegin, .blackGradientEnd]) {
        innerColorGradient = colors
    }
    
    public func adaptUIStyle(_ uiStyle: IFUserInterfaceStyle? = nil) -> IFColorStyle {
        return IFColorStyle(colorHex: colorHex.adaptUIStyle(uiStyle), opacity: opacity)
    }
    
    public func autoAdapt(_ adapt: Bool) -> IFColorStyle {
        var cStyle = self
        cStyle.autoAdaptIfneeded = adapt
        return cStyle
    }
    
    public func adapt(colorHex: Color? = nil, colors: [Color]? = nil, opacity: Float? = nil) -> IFColorStyle {
        var style = self
        if let col = colorHex {
            style.colorHex = col
        }
        if let opa = opacity {
            style.opacity = opa
        }
        style.colorGradient = colors // optional
        return style
    }
}

extension IFColorStyle {
    /// 错误
    public static let error: IFColorStyle = IFColorStyle(colorHex: .red, opacity: IFOpacity.medium)
    /// 普通 黑色
    public static let common: IFColorStyle = IFColorStyle(colorHex: .black, opacity: IFOpacity.full)
    /// 白色
    public static let white: IFColorStyle = IFColorStyle(colorHex: .white, opacity: IFOpacity.full)
    /// 黑色
    public static let black: IFColorStyle = IFColorStyle(colorHex: .black, opacity: IFOpacity.full)
    /// 黑色渐变
    public static let blackGradient: IFColorStyle = IFColorStyle()
    /// 金色渐变
    public static let goldenGradient: IFColorStyle = IFColorStyle(colors: [.goldenGradientBegin, .goldenGradientEnd])
}

fileprivate let customColors: [String: UIColor] = [
    // • Theme/Assets/Colors.xcassets/
    "whiteVC": UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
    "whiteVCDark": UIColor(red: 0.07450980392156863, green: 0.07450980392156863, blue: 0.07450980392156863, alpha: 1.0),
    "grayImageBg": UIColor(red: 0.9411764705882353, green: 0.9411764705882353, blue: 0.9411764705882353, alpha: 1.0),
    "grayImageBgDark": UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0),
    "grayD8D8D8": UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha: 1.0),
    "blackShadow": UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
    "blackPanel": UIColor(red: 0.1568627450980392, green: 0.1568627450980392, blue: 0.1568627450980392, alpha: 1.0),
    "blackGradientBegin": UIColor(red: 0.2784313725490196, green: 0.2784313725490196, blue: 0.2784313725490196, alpha: 1.0),
    "graySpan": UIColor(red: 0.5490196078431373, green: 0.5411764705882353, blue: 0.5411764705882353, alpha: 1.0),
    "whiteNaviBarBg": UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
    "whiteNaviBarBgDark": UIColor(red: 0.12941176470588237, green: 0.12941176470588237, blue: 0.12941176470588237, alpha: 1.0),
    "goldenGradientEnd": UIColor(red: 0.9019607843137255, green: 0.8117647058823529, blue: 0.7568627450980392, alpha: 1.0),
    "goldenGradientEndDark": UIColor(red: 0.8431372549019608, green: 0.7254901960784313, blue: 0.6509803921568628, alpha: 1.0),
    "whiteCellHighlight": UIColor(red: 0.9333333333333333, green: 0.9333333333333333, blue: 0.9333333333333333, alpha: 1.0),
    "whiteCellHighlightDark": UIColor(red: 0.1568627450980392, green: 0.1568627450980392, blue: 0.1568627450980392, alpha: 1.0),
    "goldenBackground": UIColor(red: 0.871, green: 0.714, blue: 0.608, alpha: 1.0),
    "goldenFlag": UIColor(red: 0.8705882352941177, green: 0.7137254901960784, blue: 0.6078431372549019, alpha: 1.0),
    "yellowFlag": UIColor(red: 0.984313725490196, green: 0.9490196078431372, blue: 0.9294117647058824, alpha: 1.0),
    "yellowFlagDark": UIColor(red: 0.19607843137254902, green: 0.1803921568627451, blue: 0.16862745098039217, alpha: 1.0),
    "gray999": UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0),
    "gray999Dark": UIColor(red: 0.5019607843137255, green: 0.5019607843137255, blue: 0.5019607843137255, alpha: 1.0),
    "gray666": UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0),
    "whiteListVC": UIColor(red: 0.9607843137254902, green: 0.9607843137254902, blue: 0.9607843137254902, alpha: 1.0),
    "whiteListVCDark": UIColor(red: 0.07450980392156863, green: 0.07450980392156863, blue: 0.07450980392156863, alpha: 1.0),
    "grayImageBorder": UIColor(red: 0.804, green: 0.804, blue: 0.804, alpha: 1.0),
    "grayImageBorderDark": UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0),
    "goldenBtnText": UIColor(red: 0.4666666666666667, green: 0.3686274509803922, blue: 0.2901960784313726, alpha: 1.0),
    "goldenShadow": UIColor(red: 0.8941176470588236, green: 0.7254901960784313, blue: 0.615686274509804, alpha: 1.0),
    "goldenShadowDark": UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
    "goldenDesc": UIColor(red: 0.9176470588235294, green: 0.803921568627451, blue: 0.7294117647058823, alpha: 0.25),
    "blackBg": UIColor(red: 0.12549019607843137, green: 0.13725490196078433, blue: 0.16470588235294117, alpha: 1.0),
    "grayCancelBg": UIColor(red: 0.9137254901960784, green: 0.9137254901960784, blue: 0.9137254901960784, alpha: 1.0),
    "goldenGradientBegin": UIColor(red: 0.984313725490196, green: 0.9176470588235294, blue: 0.8784313725490196, alpha: 1.0),
    "goldenGradientBeginDark": UIColor(red: 0.9686274509803922, green: 0.8784313725490196, blue: 0.8156862745098039, alpha: 1.0),
    "whiteText": UIColor(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412, alpha: 1.0),
    "grayText": UIColor(red: 0.7098039215686275, green: 0.7137254901960784, blue: 0.7176470588235294, alpha: 1.0),
    "grayTextDark": UIColor(red: 0.5019607843137255, green: 0.5019607843137255, blue: 0.5019607843137255, alpha: 1.0),
    "blackGradientEnd": UIColor(red: 0.1568627450980392, green: 0.1568627450980392, blue: 0.1568627450980392, alpha: 1.0),
    "whiteSectionBg": UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
    "whiteSectionBgDark": UIColor(red: 0.13333333333333333, green: 0.13333333333333333, blue: 0.13333333333333333, alpha: 1.0),
    "blackDesc": UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0),
    "red": UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
    "black": UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0),
    "blackDark": UIColor(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412, alpha: 1.0),
    "golden": UIColor(red: 0.8980392156862745, green: 0.788235294117647, blue: 0.7137254901960784, alpha: 1.0),
    "orange": UIColor(red: 0.9215686274509803, green: 0.5647058823529412, blue: 0.30196078431372547, alpha: 1.0),
    "gray": UIColor(red: 0.9137254901960784, green: 0.9137254901960784, blue: 0.9137254901960784, alpha: 1.0),
    "grayDark": UIColor(red: 0.5019607843137255, green: 0.5019607843137255, blue: 0.5019607843137255, alpha: 1.0),
    "white": UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
    "whiteDark": UIColor(red: 0.07450980392156863, green: 0.07450980392156863, blue: 0.07450980392156863, alpha: 1.0),
]

/// 主题风格应用协议
@objc public protocol IFThemeDelegate: NSObjectProtocol {
    
    @objc optional var userInterfaceStyle: IFUserInterfaceStyle { get set }
    
    @objc optional func setupTheme()
    
    @objc optional func didThemeChanged(_ uiStyle: IFUserInterfaceStyle)
}

extension CGFloat {
    public func adaptLineGap(_ fontSelf: UIFont?, fontRelated: UIFont? = nil) -> CGFloat {
        var value = self
        if let fos = fontSelf {
            value -= fos.getLeadingHeight()
        }
        if let fot = fontRelated {
            value -= fot.getLeadingHeight()
        }
        return value
    }
}


public extension UIImage {
    static func imageWithHexColors(_ hexStringColors: [String],
                                   gType: FXGradientType?,
                                   size: CGSize,
                                   locations: [CGFloat] = [0, 1],
                                   scale:CGFloat = 1.0) -> UIImage? {
        if hexStringColors.count == 0 {
            return nil
        }
        if scale == 1.0 {
            var cors: [UIColor] = []
            for cor in hexStringColors {
                if let color = UIColor.init(hexString: cor) {
                    cors.append(color)
                }
            }
            
            return self.imageWithColors(cors, gType: gType, size: size, locations: locations)
        }else {
            var cors: [CGColor] = []
            for cor in hexStringColors {
                if let color = UIColor.init(hexString: cor) {
                    cors.append(color.cgColor)
                }
            }
            return self.imageWith(gradient: cors, gType: gType, size: size,locations: locations,cornerRadius: 0,alpha: 1.0,scale: scale)
        }
      
    }
    
    static func imageWithColors(_ colors: [UIColor],
                                gType: FXGradientType?,
                                size: CGSize,
                                locations: [CGFloat]?,
                                cornerRadius: CGFloat = 0.0,
                                alpha: CGFloat = 1.0) -> UIImage? {
        
        var arrCGColor: [CGColor] = []
        for color in colors {
            arrCGColor.append(color.cgColor)
        }
        
        return imageWith(gradient: arrCGColor,
                         gType: gType,
                         size: size,
                         locations: locations,
                         cornerRadius: cornerRadius,
                         alpha: alpha)
    }
    
    static func imageWith(gradient colors: [CGColor],
                          gType: FXGradientType?,
                          size: CGSize,
                          locations: [CGFloat]? = nil,
                          cornerRadius: CGFloat = 0.0,
                          alpha: CGFloat = 1.0,
                          scale: CGFloat = 1.0) -> UIImage? {
        if colors.count == 0 {
            return nil
        }
        
        // 控制画布精度
        let sizeTarget = CGSize.init(width: size.width.rounded(.up), height: size.height.rounded(.up))
        
        var image: UIImage?
        if colors.count == 1 {
            image = imageWithColor(UIColor.init(cgColor: colors.first!), size: sizeTarget, alpha: alpha)
        } else {
            UIGraphicsBeginImageContextWithOptions(sizeTarget, false, scale)
            if let context: CGContext = UIGraphicsGetCurrentContext() {
                // 检查locations，值必须是0~1，且与颜色数量一致
                var locs: [CGFloat] = [0, 1]
                if locations == nil || (locations?.count != colors.count && colors.count>2) {
                    let average:CGFloat = CGFloat(1.0)/CGFloat(colors.count-1)
                    locs = []
                    locs.append(0)
                    for i in 1..<colors.count-1 {
                        let result = average*CGFloat(i)
                        locs.append(result)
                    }
                    locs.append(1)
                } else if let locas = locations, locas != locs {
                    locs = []
                    for loc in locas {
                        locs.append(loc)
                    }
                }
                
                let width = sizeTarget.width, height = sizeTarget.height
                var start = CGPoint.init(x: width, y: 0), end = CGPoint.init(x: width, y: height)
                
                // 这里的点指的是frame关系
                switch gType ?? .bottomToTop {
                case .leftToRight:
                    start = CGPoint.init(x: 0, y: height)
                case .upLeftToLowRight:
                    start = CGPoint.init(x: 0, y: 0)
                case .upRightToLowLeft:
                    start = CGPoint.init(x: width, y: 0)
                    end = CGPoint.init(x: 0, y: height)
                case .bottomToTop:
                    start = CGPoint.init(x: width, y: height)
                    end = CGPoint.init(x: width, y: 0)
                case .RightToLeft:
                    start = CGPoint.init(x: width, y: height)
                    end = CGPoint.init(x: 0, y: height)
                default:
                    break
                }
                
                context.setAlpha(alpha)
                if let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                                  colors: colors as CFArray,
                                                  locations: locs) {
                    context.drawLinearGradient(gradient, start: start,
                                               end: end,
                                               options: CGGradientDrawingOptions())
                    image = UIGraphicsGetImageFromCurrentImageContext()
                }
            }
            UIGraphicsEndImageContext()
        }

        return image
    }
    func imageBlured(radius: CGFloat?, size: CGSize?, contentModel: UIView.ContentMode = .scaleAspectFill, scale: CGFloat = 1.0, blend:[CGColor]?, blendLoc: [CGFloat]? = nil, blendOpacity: Float?, opaque: Bool = true) -> UIImage? {
        
        let targetSize = size ?? self.size
        let targetFrame = CGRect.init(origin: CGPoint.init(), size: targetSize)
        
        // 适配填充
        var rect = UIImage.caculateFitRect(model: contentModel, canvasSize: targetSize, fitSize: self.size)
        
        // 扩大比例
        if scale != 1.0 {
            rect = rect.insetBy(dx: rect.width*(1-scale), dy: rect.height*(1-scale))
        }
        
        UIGraphicsBeginImageContextWithOptions(targetSize, opaque, 1.0)
        guard let _ = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        self.draw(in: rect)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        // 如果没有配置radius，那么根据机型控制；
        let r = radius ?? 30 //* ratioOfScreenWidthEx
        if let img = image.bluredWithFilter(r) {
            UIGraphicsBeginImageContextWithOptions(targetFrame.size, opaque, 1.0)
            img.draw(in: targetFrame)
            
            if let colors = blend {
                if let gradientImg = UIImage.imageWith(gradient: colors, gType: .topToBottom, size: targetSize, locations: blendLoc, alpha: CGFloat(blendOpacity ?? 1.0)) {
                    gradientImg.draw(in: targetFrame)
                }
            }
            
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
        
        return nil
    }
    func bluredWithFilter(_ radius: CGFloat) -> UIImage? {
        if let ciimage = CIImage.init(image: self) {
            let bluredImage = ciimage
                .clampedToExtent()
                .applyingFilter(
                    "CIGaussianBlur",
                    parameters: [
                        kCIInputRadiusKey: radius,
                ])
                .applyingFilter("CIColorControls",
                                parameters: [
                                    kCIInputSaturationKey: 1.5,
                                    kCIInputBrightnessKey: 0,
                                    kCIInputContrastKey: 1,
                ])
                .cropped(to: ciimage.extent)
            if let cgimage = CIContext.init().createCGImage(bluredImage, from: bluredImage.extent) {
                return UIImage.init(cgImage: cgimage)
            }
        }
        return self
    }
    
    static func imageWithColor(_ color: UIColor?, size: CGSize, alpha: CGFloat = 1.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color?.setFill()
        UIGraphicsGetCurrentContext()?.setAlpha(alpha)
        UIRectFill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    

}


extension UIView {
    /// 获取view的快照图片
    func snapshot(_ alpha: CGFloat = 1.0, opaque: Bool = false, size: CGSize = .zero) -> UIImage? {
        return UIView.screenshot(self, alpha: alpha, opaque: opaque, size: size)
    }
    
    static func screenshot(_ targetView: UIView = UIApplication.shared.keyWindow!, alpha: CGFloat = 1.0, opaque: Bool = false, size: CGSize = .zero) -> UIImage? {
        var screenshotImage :UIImage?
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        let baseView = targetView
        let scale = UIScreen.main.scale
        let targetRect: CGRect = (size != .zero ? CGRect(x: 0, y: 0, width: size.width, height: size.height) : baseView.bounds)
        UIGraphicsBeginImageContextWithOptions(targetRect.size, opaque, scale);
        if let context = UIGraphicsGetCurrentContext() {
            if !baseView.drawHierarchy(in: targetRect, afterScreenUpdates: false) {
                baseView.layer.render(in:context)
            }
            context.setAlpha(alpha)
        }
        
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return screenshotImage
    }
}

public enum FXGradientType: Int8 {
    case bottomToTop = 0
    case topToBottom
    case leftToRight
    case RightToLeft
    
    case upLeftToLowRight = 4
    case upRightToLowLeft
}

extension UIFont {
    
    public func getLeadingHeight() -> CGFloat {
        (lineHeight - pointSize) / 2.0
    }

    public func getLineSpace() -> CGFloat {
        var space = pointSize * 7 / 15
        space -= getLeadingHeight() * 2
        return max(space, 2)
    }
}


public let ScreenHeight_FX = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
public let ScreenWidth_FX  = min(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
let widthDefer: CGFloat = 375.0 // iPhone6~iPhoneX
let heightDefer: CGFloat = 734.0//812-34-44
let ratioOfScreenWidth: CGFloat = 1.0 // ScreenWidth/widthDefer
/** 实际的比例关系 */
let ratioOfScreenWidthEx: CGFloat = ScreenWidth_FX/widthDefer
let ratioOfScreenHeightEx: CGFloat = ScreenHeight_FX/heightDefer

// MARK: - 适配机型用
extension CGFloat {
    
    public func adaptedValue() -> CGFloat {
        if UIScreen.main.bounds.width < 375 {
            return self
        }
        
        return self * ratioOfScreenWidth
    }
    
    public func adaptedActualWidthRatioValue(justAdaptBelowIPhone6: Bool = false) -> CGFloat {
        if justAdaptBelowIPhone6 {
            if ratioOfScreenWidthEx > 1 {
                return self
            }
        }
        return self * ratioOfScreenWidthEx
    }
    
    public func adaptedActualHeightRatioValue() -> CGFloat {
        return self * ratioOfScreenHeightEx
    }
    
}
