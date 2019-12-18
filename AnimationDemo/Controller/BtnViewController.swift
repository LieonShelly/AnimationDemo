//
//  BtnViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/25.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BtnViewController: UIViewController {
    var destinationRect = CGRect(x: UIScreen.main.bounds.width - 100, y: 100, width: 44, height: 44)
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [#colorLiteral(red: 0.4784313725, green: 0.8274509804, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.2549019608, blue: 0.8274509804, alpha: 1).cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    
    lazy var shapeLapyer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        return shapeLayer
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(type: .custom)
        let btnBounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        btn.frame.size = btnBounds.size
        btn.center = view.center
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 30
        btn.layer.shadowPath = CGPath(roundedRect: btnBounds,
                                      cornerWidth: 30,
                                      cornerHeight: 30, transform: nil)
        btn.layer.shadowColor = UIColor.red.cgColor
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 10
        btn.layer.shadowOpacity = 1
        view.addSubview(btn)
        
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = 10
        layerAnimation.toValue = 1
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = 0.25
        layerAnimation.fillMode = .forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        btn.layer.add(layerAnimation, forKey: nil)
        
        shapeLapyer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: destinationRect.height, height: destinationRect.height), cornerRadius: destinationRect.height * 0.5).cgPath
        shapeLapyer.lineWidth = 5
        gradientLayer.frame = destinationRect
        gradientLayer.removeAllAnimations()
        gradientLayer.mask = shapeLapyer
        gradientLayer.cornerRadius = destinationRect.height * 0.5
        view.layer.addSublayer(gradientLayer)
        
    }
    
}


class FXTutorialHandlerAlert: UIView {
    struct UISize {
        static let iconHeight: CGFloat = 28.0.fitiPhone5sSerires
        static let btnHeight: CGFloat = 46.0.fitiPhone5sSerires
        static let contentViewWidth: CGFloat = 290.0.fit375Pt
    }
    let bag = DisposeBag()
    fileprivate lazy var containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    var dismissHandler: ((Any?) -> Void)?
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12.0.fitiPhone5sSerires
        view.layer.masksToBounds = true
        return view
    }()
    fileprivate lazy var noConorContentView: UIView = {
        let titleView = UIView()
        return titleView
    }()
    
    fileprivate lazy var upContentBgView: UIImageView = {
        let bgView = UIImageView()
        bgView.image = UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_tuotorial_alert_bg@3x"))
        return bgView
    }()
    
    fileprivate lazy var iconView: UIImageView = {
        let bgView = UIImageView()
        bgView.image = UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_tutorial_alert_yls@3x"))
        return bgView
    }()
    
    fileprivate lazy var titleBgView: UIImageView = {
        let bgView = UIImageView()
        bgView.image = UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_tutotial_alert_title_bg@3x"))
        return bgView
    }()
    
    fileprivate lazy var titleView: UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var upContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let bgView = UILabel()
        bgView.textAlignment = .center
        bgView.font = UIFont.customFont(ofSize: 18.0.fitiPhone5sSerires, isBold: true)
        bgView.textColor = .white
        return bgView
    }()
    
    fileprivate lazy var okButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(" 去看看", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 16.0.fitiPhone5sSerires, isBold: true)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(okAction(_:)), for: UIControl.Event.touchUpInside)
        var icon = UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_tutorial_alter_contine@3x"))
        btn.setImage(icon, for: .normal)
        return btn
    }()
    
    lazy var shapeLapyer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        return shapeLayer
    }()
    
    lazy var bottomShadowLayer: CALayer = {
        $0.contentsScale = UIScreen.main.scale
        $0.contents = UIImage(named: "bottom_shadow")?.cgImage
        return $0
    }(CALayer())
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [#colorLiteral(red: 0.4784313725, green: 0.8274509804, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.2549019608, blue: 0.8274509804, alpha: 1).cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    fileprivate lazy var descLabel: UILabel = {
        let bgView = UILabel()
        bgView.text = "使用小涂抹擦除边缘纹理，使照片融入画面更显自然"
        bgView.font = UIFont.customFont(ofSize: 16.0.fitiPhone5sSerires)
        bgView.textAlignment = .center
        bgView.textColor = UIColor(hex: 0x808080)
        bgView.numberOfLines = 0
        return bgView
    }()
    fileprivate var layerBoundsInView: CGRect = .zero
    var destinationRect = CGRect(x: UIScreen.main.bounds.width - 100, y: 100, width: 44, height: 44)
    fileprivate var heightCaculated: CGFloat = 0
    fileprivate var iconURL: String?
    fileprivate var inputTitle: String?
    fileprivate var desc: String?
    fileprivate lazy var coverBtn: UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return btn
    }()
    fileprivate var isFirstLayoutSubLayer: Bool = true
    
    fileprivate  class FXButton: UIButton {
        override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
            let imageSize: CGSize = CGSize(width: 24.fitiPhone5sSerires, height: 24.0.fitiPhone5sSerires)
            return CGRect(x: (contentRect.width - imageSize.width) * 0.5,
                          y: (contentRect.height - imageSize.height) * 0.5,
                          width: imageSize.width,
                          height: imageSize.height)
        }
    }
    
    convenience init(_ iconURL: String?,
                     title: String?,
                     desc: String?) {
        self.init(frame: UIScreen.main.bounds)
        self.iconURL = iconURL
        self.inputTitle = title
        self.desc = desc
        setupUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        configUI(iconURL,
                 title: inputTitle,
                 desc: desc)
    }
    
    func showAnimation() {
        self.containerView.center.y = -UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.containerView.center.y = UIScreen.main.bounds.height * 0.5
        }) { (finished) in
            
        }
    }
    
    func show(_ dismiss: ((Any?) -> Void)?) {
        let tag = -19992
        self.tag = tag
        let keyWindow = UIApplication.shared.keyWindow!
        for sub in keyWindow.subviews where sub.tag == tag {
            sub.removeFromSuperview()
        }
        self.dismissHandler = dismiss
        keyWindow.addSubview(self)
        self.showAnimation()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if isFirstLayoutSubLayer {
            isFirstLayoutSubLayer = false
            let gradientWidth = bounds.width - ((bounds.width - UISize.contentViewWidth) * 0.5 + 26.0.fitiPhone5sSerires) * 2
            gradientLayer.frame = CGRect(x: 0, y: 0, width: gradientWidth, height: UISize.btnHeight)
            gradientLayer.cornerRadius = 10.0.fitiPhone5sSerires
            okButton.layer.insertSublayer(gradientLayer, below: okButton.imageView?.layer)
            bottomShadowLayer.frame = CGRect.init(x: 0, y: UISize.btnHeight - 2, width: gradientWidth, height: 7.0)
            okButton.layer.insertSublayer(bottomShadowLayer, below: gradientLayer)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self)  else {
            return
        }
        if gradientLayer.frame == destinationRect, destinationRect.contains(point) {
            dismiss(true, result: true)
        } else {
            dismiss(true, result: false)
        }
        
    }
}

extension FXTutorialHandlerAlert {
    
    fileprivate func configUI(_  iconURL: String?,
                              title: String?,
                              desc: String?) {
        let widthAlert: CGFloat = CGFloat(290).adaptedValue()
        let viewAlertBg = containerView
        addSubview(coverBtn)
        coverBtn.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.left.equalTo(30.0.fitiPhone5sSerires)
            $0.right.equalTo(-30.0.fitiPhone5sSerires)
            $0.centerX.equalTo(self.snp.centerX)
            $0.height.greaterThanOrEqualTo(10.0.fitiPhone5sSerires)
        }
        viewAlertBg.backgroundColor = .clear
        if let iconURL = iconURL {
            let icon = UIImage(contentsOfFile: Bundle.getFilePath(fileName: iconURL))
            iconView.image =  icon
        }
        titleLabel.text = title
        let descAttr = NSMutableAttributedString(string: desc ?? "")
        let style = NSMutableParagraphStyle()
        let spacing: CGFloat = 4.0.fitiPhone5sSerires
        style.lineSpacing = spacing
        style.lineBreakMode = .byWordWrapping
        style.alignment = .justified
        descAttr.addAttributes([NSAttributedString.Key.font : UIFont.customFont(ofSize: 16.0.fitiPhone5sSerires),
                                NSAttributedString.Key.paragraphStyle : style],
                               range: NSRange(location: 0, length: descAttr.string.count))
        descLabel.attributedText = descAttr
        let ylsHeight: CGFloat = 124.0.fitiPhone5sSerires
        let titleTop: CGFloat = 36.0.fitiPhone5sSerires - spacing
        let titleHeight: CGFloat = descAttr.boundingRect(with: CGSize(width: widthAlert - 25.0.fitiPhone5sSerires * 2, height: .infinity), options: .usesLineFragmentOrigin, context: nil).size.height
        let titleBottom: CGFloat = 34.0.fitiPhone5sSerires - spacing
        let btnHeight: CGFloat = 50.0.fitiPhone5sSerires
        let btnBottom: CGFloat = 26.0.fitiPhone5sSerires
        viewAlertBg.addSubview(noConorContentView)
        noConorContentView.snp.makeConstraints {
            $0.center.equalTo(viewAlertBg.snp.center)
            $0.width.equalTo(UISize.contentViewWidth)
            $0.height.greaterThanOrEqualTo(0)
        }
        noConorContentView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
        contentView.addSubview(upContentView)
        upContentView.snp.makeConstraints {
            $0.left.right.top.equalTo(0)
            $0.height.equalTo(76.0.fitiPhone5sSerires)
        }
        upContentView.addSubview(upContentBgView)
        upContentBgView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
        noConorContentView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.equalTo(20.0.fitiPhone5sSerires)
            $0.left.equalTo(-10.0.fitiPhone5sSerires)
            $0.height.equalTo(45.0.fitiPhone5sSerires)
            $0.width.equalTo(158.0.fitiPhone5sSerires)
        }
        titleView.addSubview(titleBgView)
        titleBgView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(7.0.fitiPhone5sSerires)
            $0.centerX.equalTo(titleView.snp.centerX)
            $0.height.equalTo(25.0.fitiPhone5sSerires)
        }
        noConorContentView.addSubview(iconView)
        iconView.image = UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_tutorial_alert_yls@3x"))
        iconView.snp.makeConstraints {
            $0.bottom.equalTo(upContentView.snp.bottom)
            $0.right.equalTo(-5.0.fitiPhone5sSerires)
            $0.width.equalTo(ylsHeight)
            $0.height.equalTo(ylsHeight)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.equalTo(25.0.fitiPhone5sSerires)
            $0.right.equalTo(-25.0.fitiPhone5sSerires)
            $0.height.equalTo(titleHeight)
            $0.top.equalTo(upContentView.snp.bottom).offset(titleTop)
        }
        
        contentView.addSubview(okButton)
        okButton.snp.makeConstraints {
            $0.left.equalTo(26.0.fitiPhone5sSerires)
            $0.right.equalTo(-26.0.fitiPhone5sSerires)
            $0.top.equalTo(descLabel.snp.bottom).offset(titleBottom)
            $0.bottom.equalTo(-btnBottom)
            $0.height.equalTo(btnHeight)
        }
        
        heightCaculated = ylsHeight + titleTop + titleHeight + titleBottom + btnHeight + btnBottom
        
        containerView.snp.remakeConstraints {
            $0.left.equalTo(30.0.fitiPhone5sSerires)
            $0.right.equalTo(-30.0.fitiPhone5sSerires)
            $0.centerY.equalTo(self.snp.centerY)
            $0.height.equalTo(heightCaculated)
        }
    }
    
    fileprivate func dismiss(_ callback: Bool, result: Any?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.001
        }, completion: { _ in
            if callback {
                self.dismissHandler?(result)
            }
            self.removeFromSuperview()
        })
    }
    
    @objc func okAction(_ sender: Any?) {
        exchangeSuperLayer()
        circularAnimations()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) { [unowned self] in
            self.moveToNavAnimation()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) { [unowned self] in
            self.breathAnimation()
        }
    }
    
    fileprivate func exchangeSuperLayer() {
        let gradientBounds = gradientLayer.convert(gradientLayer.bounds, to: self.layer)
        gradientLayer.removeFromSuperlayer()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = gradientBounds
        CATransaction.commit()
        layer.addSublayer(gradientLayer)
        layerBoundsInView = CGRect(x: gradientBounds.origin.x + gradientBounds.width/2 -  UISize.btnHeight * 0.5, y: gradientBounds.origin.y, width:  UISize.btnHeight, height:  UISize.btnHeight)
    }
    
    fileprivate func circularAnimations() {
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = CACurrentMediaTime()
        groupAnimation.duration = 0.5
        groupAnimation.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        groupAnimation.isRemovedOnCompletion = false
        
        let bounds = CABasicAnimation(keyPath: "bounds")
        bounds.fromValue = gradientLayer.bounds
        bounds.toValue = layerBoundsInView
        
        let position = CABasicAnimation(keyPath: "position")
        position.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        position.isRemovedOnCompletion = false
        position.fromValue = CGPoint(x: layerBoundsInView.origin.x + UISize.btnHeight * 0.5, y: layerBoundsInView.origin.y +  UISize.btnHeight * 0.5)
        position.toValue = CGPoint(x: destinationRect.origin.x +  UISize.btnHeight * 0.5, y: destinationRect.origin.y +  UISize.btnHeight * 0.5)
        position.duration = 0.5
        
        let cornerRadius = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadius.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "linear"))
        cornerRadius.fromValue = 8
        cornerRadius.toValue =  UISize.btnHeight * 0.5
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        fade.isRemovedOnCompletion = false
        fade.fromValue = 1
        fade.toValue = 0
        containerView.layer.opacity = 0
        groupAnimation.animations = [bounds, cornerRadius]
        containerView.layer.add(fade, forKey: "fade")
        coverBtn.layer.add(fade, forKey: nil)
        gradientLayer.add(groupAnimation, forKey: "group")
    }
    
    fileprivate func moveToNavAnimation() {
        let position = CABasicAnimation(keyPath: "position")
        position.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        position.isRemovedOnCompletion = false
        position.fromValue = CGPoint(x: layerBoundsInView.origin.x +  UISize.btnHeight * 0.5, y: layerBoundsInView.origin.y +  UISize.btnHeight * 0.5)
        position.toValue = CGPoint(x: destinationRect.origin.x +  UISize.btnHeight * 0.5, y: destinationRect.origin.y +  UISize.btnHeight * 0.5)
        position.duration = 0.5
        gradientLayer.add(position, forKey: "position")
    }
    
    fileprivate  func breathAnimation() {
        shapeLapyer.lineWidth = destinationRect.height
        shapeLapyer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: destinationRect.height, height: destinationRect.height), cornerRadius: destinationRect.height * 0.5).cgPath
        gradientLayer.frame = destinationRect
        gradientLayer.removeAllAnimations()
        gradientLayer.mask = shapeLapyer
        gradientLayer.cornerRadius = destinationRect.height * 0.5
        
        let circle = CABasicAnimation(keyPath: "lineWidth")
        circle.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        circle.isRemovedOnCompletion = false
        circle.fromValue = destinationRect.height
        circle.toValue = 5
        circle.duration = 0.25
        
        let scale = CAKeyframeAnimation(keyPath: "transform.scale")
        scale.repeatCount = MAXFLOAT
        scale.values = [1, 1.3, 1]
        scale.keyTimes = [0, 0.5, 1]
        scale.duration = 2.5
        scale.beginTime = 0.25
        
        gradientLayer.add(scale, forKey: "scale")
        shapeLapyer.add(circle, forKey: "circle")
    }
}




extension Bundle {
    static func getFilePath(fileName: String,
                            fileType: String = "png") -> String {
        if let str =  Bundle.main.path(forResource: fileName + "@3x", ofType: fileType) {
            return str
        } else if let str = Bundle.main.path(forResource: fileName, ofType: fileType) {
            return str
        }
        return ""
    }
}

extension Double {
    var fitiPhone5sSerires: CGFloat {
        let deviceWidth = UIScreen.main.bounds.width
          if deviceWidth <= 640 * 0.5 { // 5s
              return fit375Pt
          } else {
            return CGFloat(self)
        }
    }
}

public extension UIFont {
    
    enum UIFontNameSpecs: String {
        case regular = "PingFangSC-Regular"
        case medium = "PingFangSC-Medium"
        case bold = "PingFangSC-Semibold"
    }
    
    /** 常规 */
    static let def_fontName: String = UIFontNameSpecs.regular.rawValue
    /** 中等粗 */
    static let def_fontName_medium: String = UIFontNameSpecs.medium.rawValue
    /** 粗体 - 使用较少 */
    static let def_fontName_bold: String = UIFontNameSpecs.bold.rawValue
    
    /// 外部自己控制是否应用机型适配值
    static func customFontOffsetAdapt(ofSize: CGFloat, isBold: Bool = false) -> UIFont {
        let fontName = isBold ? def_fontName_medium : def_fontName
        
        if let font = UIFont.init(name: fontName, size: ofSize) {
            return font
        }
        
        return UIFont.systemFont(ofSize: ofSize)
    }
    
    static func customFont(ofSize: CGFloat, isBold: Bool) -> UIFont {
        return customFont(def_fontName, ofSize: ofSize, isBold: isBold)
    }
    
    static func customFont(ofSize: CGFloat, spec: UIFontNameSpecs) -> UIFont {
        return customFont(spec.rawValue, ofSize: ofSize, isBold: false)
    }
    
    static func customFont(_ name: String = def_fontName, ofSize: CGFloat, isBold: Bool = false) -> UIFont {
        let fontName = (isBold && name == def_fontName) ? def_fontName_medium : name
        
        if let font = UIFont.init(name: fontName, size: ofSize.adaptedValue()) {
            return font
        }
        
        return UIFont.systemFont(ofSize: ofSize.adaptedValue())
    }
    
}


extension CGFloat {
    
    public func adaptedValue() -> CGFloat {
      return self
    }
}
