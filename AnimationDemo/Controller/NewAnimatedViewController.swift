//
//  NewAnimatedViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/1/11.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class NewAnimatedViewController: UIViewController {
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var naviBar: UIView!
    fileprivate var naviBarOriginFrame: CGRect = .zero
    fileprivate var isShow: Bool = false
    fileprivate lazy var tipPop: FXTutorialRobotView = FXTutorialRobotView()
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.layer.cornerRadius = 10
        naviBar.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 10
        nextBtn.layer.masksToBounds = true
        naviBar.alpha = 0
        tipPop.config("模拟操作中...")
        tipPop.alpha = 0
        tipPop.rebotView.alpha = 0
        tipPop.popView.alpha = 0
        view.addSubview(tipPop)
        tipPop.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.size.equalTo(CGSize(width: 100, height: 30))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    @IBAction func btnClick(_ sender: Any) {
        if isShow {
            dismissAnimation()
        } else {
            showAnimation()
        }
    }
    
    fileprivate func dismissAnimation() {
        naviBar.setAnchorPoint(CGPoint(x: 0, y: 0.5))
        UIView.animateKeyframes(withDuration: 0.5,
                                delay: 0,
                                options: [.calculationModeLinear],
                            animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25) {
                                                        self.naviBar.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                       relativeDuration: 0.25) {
                                                        self.naviBar.transform = CGAffineTransform(scaleX: 0, y: 0)
                                    }
        }, completion: { _ in
            self.naviBar.transform = .identity
            self.naviBar.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
        })
        
        UIView.animateKeyframes(withDuration: 0.25,
                                delay: 0.0,
                                options: [.calculationModeLinear],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.125) {
                                                        self.nextBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.125,
                                                       relativeDuration: 0.125) {
                                                        self.nextBtn.transform = CGAffineTransform(scaleX: 0, y: 0)
                                    }
        }, completion: { _ in
            self.isShow = false
        })
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.naviBar.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.5,
                       options: [.curveEaseInOut],
                       animations: {
                        self.tipPop.alpha = 0
        }, completion: nil)
    }
    
    fileprivate func showAnimation() {
        tipPop.alpha = 1
        tipPop.rebotView.alpha = 0
        tipPop.popView.alpha = 0
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.tipPop.rebotView.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.25,
                       delay: 0.25,
                       options: [.curveEaseInOut],
                       animations: {
                        self.tipPop.popView.alpha = 1
        }, completion: nil)
        
        naviBar.alpha = 1
        naviBar.setAnchorPoint(CGPoint(x: 0, y: 0.5))
        naviBar.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5,
                       delay: 0.25 + 0.25,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.naviBar.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            self.naviBar.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
        })
        nextBtn.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.25,
                       delay: 0.25 + 0.25 + 0.25,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.nextBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            self.isShow = true
        })
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.25 + 0.25,
                       options: [.curveEaseInOut],
                       animations: {
                        self.naviBar.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.35,
                       delay: 0.25 + 0.25,
                       options: [.curveEaseInOut],
                       animations: {
                        self.nextBtn.alpha = 1
        }, completion: nil)
        
    }
}


class FXTutorialRobotView: UIView {
    
    fileprivate lazy var rebotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    fileprivate lazy var popView: FXTutorialTipPop = {
        let view = FXTutorialTipPop()
        view.alpha = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(rebotView)
        addSubview(popView)
        rebotView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 50, height: 50))
        }
        popView.snp.makeConstraints {
            $0.left.equalTo(rebotView.snp.right)
            $0.centerY.equalTo(rebotView.snp.centerY)
            $0.height.equalTo(30)
            $0.width.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    fileprivate class FXTutorialTipPop: UIView {
        fileprivate struct UISize {
            fileprivate static let triangleSize = CGSize(width: 5, height: 10)
            fileprivate static let rectRadius: CGFloat = 5
            fileprivate static let descLabelInset: CGFloat = 13
        }
        fileprivate lazy var popBgLalyer: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.backgroundColor = UIColor.clear.cgColor
            layer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
            return layer
        }()
        fileprivate lazy var descLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.customFont(ofSize: 11)
            label.textColor = UIColor.white
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.addSublayer(popBgLalyer)
            addSubview(descLabel)
            descLabel.snp.makeConstraints {
                $0.left.equalTo(UISize.descLabelInset)
                $0.centerY.equalTo(snp.centerY)
            }
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        override func layoutSublayers(of layer: CALayer) {
            super.layoutSublayers(of: layer)
            popBgLalyer.frame = bounds
            let rectRadius: CGFloat = UISize.rectRadius
            let triangleSize = UISize.triangleSize
            let triangleRect = CGRect(x: 0,
                                      y: bounds.height * 0.5 - triangleSize.height * 0.5,
                                      width: triangleSize.width,
                                      height: triangleSize.height)
            let roundRect = CGRect(x: triangleRect.maxX,
                                   y: 0,
                                   width: bounds.width - triangleRect.maxX,
                                   height: bounds.height)
            let path = UIBezierPath(roundedRect: roundRect, cornerRadius: rectRadius)
            let trianglePath = UIBezierPath()
            trianglePath.move(to: CGPoint(x: 0, y: triangleRect.midY))
            trianglePath.addLine(to: CGPoint(x: triangleRect.maxX, y: triangleRect.minY))
            trianglePath.addLine(to: CGPoint(x: triangleRect.maxX, y: triangleRect.maxY))
            trianglePath.addLine(to: CGPoint(x: 0, y: triangleRect.midY))
            path.append(trianglePath)
            popBgLalyer.path = path.cgPath
        }
        
        fileprivate func config(_ text: String) {
            descLabel.text = text
        }
    }
    
    
}

extension FXTutorialRobotView {
    func config(_ text: String) {
        let textAttr = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.customFont(ofSize: 11)])
        let textwidth = textAttr.boundingRect(with: CGSize(width: CGFloat.infinity, height: 30),
                                              options: .usesLineFragmentOrigin, context: nil).size.width
        popView.snp.updateConstraints {
            $0.width.equalTo(textwidth + FXTutorialTipPop.UISize.descLabelInset + FXTutorialTipPop.UISize.triangleSize.width )
        }
        layoutIfNeeded()
        popView.config(text)
    }
    
    func showAnimation() {
        self.popView.alpha = 0
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
            self.popView.alpha = 1
        }, completion: nil)
    }
}

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        let oldOrigin = frame.origin
        layer.anchorPoint = point
        let newOrigin = frame.origin
        var transition: CGPoint = .zero
        transition.x = newOrigin.x - oldOrigin.x
        transition.y = newOrigin.y - oldOrigin.y
//        center = CGPoint(x: center.x - transition.x,
//                         y: center.y - transition.y)

        center = CGPoint(x: oldOrigin.x + layer.anchorPoint.x * frame.width, y:oldOrigin.y + layer.anchorPoint.y * frame.height)
//
//        let oldFrame = frame
//        layer.anchorPoint = point
//        frame = oldFrame
    }
}




class FXTutorialHandlerAlert: UIView {
    struct AlertData {
        var iconURL: String?
        var title: String?
        var desc: String?
        var buttonTiitle: String?
        var destionationRect: CGRect = .zero
    }
    
    enum AlertType {
        case toDestination(AlertData)
        case common(AlertData)
        case none
        
        var data: AlertData? {
            switch self {
            case .toDestination(let inputData):
                return inputData
            case .common(let inputData):
                return inputData
            default:
                return nil
            }
        }
    }
    struct UISize {
        static let iconHeight: CGFloat = 28.0.fitiPhone5sSerires
        static let btnHeight: CGFloat = 46.0.fitiPhone5sSerires
        static let contentViewWidth: CGFloat = 290.0.fit375Pt
    }
    let bag = DisposeBag()
    fileprivate lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.alpha = 0
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
    fileprivate lazy var iconView: UIImageView = {
        let bgView = UIImageView()
        bgView.image = UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_tutorial_alert_yls@3x"))
        return bgView
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let bgView = UILabel()
        bgView.text = "添加烟雾".localized_FX()
        bgView.textAlignment = .center
        bgView.font = UIFont.customFont(ofSize: 17.0.fitiPhone5sSerires, isBold: true)
        bgView.textColor = UIColor(hex: 0x333333)
        return bgView
    }()
    
    fileprivate lazy var okButton: GradientButton = {
        let btn = GradientButton(button: .custom, showBottom: .none)
        btn.setTitle(" " + "去看看".localized_FX(), for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 16.0.fitiPhone5sSerires, isBold: true)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(.lightGray, for: .highlighted)
        btn.setTitleColor(.gray, for: .disabled)
        btn.addTarget(self, action: #selector(okAction(_:)), for: UIControl.Event.touchUpInside)
        var icon = UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_tutorial_alter_contine@3x"))
        btn.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        btn.setImage(icon, for: .normal)
        btn.cornerRadius = 19.0.fitiPhone5sSerires
        return btn
    }()

    fileprivate lazy var descLabel: UILabel = {
        let bgView = UILabel()
        bgView.font = UIFont.customFont(ofSize: 14.0.fitiPhone5sSerires)
        bgView.textAlignment = .center
        bgView.textColor = UIColor(hex: 0x808080)
        bgView.numberOfLines = 0
        return bgView
    }()
    fileprivate var heightCaculated: CGFloat = 0
    fileprivate lazy var coverBtn: UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = true
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        btn.addTarget(self, action: #selector(self.coverBtnAction), for: .touchUpInside)
        return btn
    }()
    
    convenience init(_ alertType: AlertType) {
        self.init(frame: UIScreen.main.bounds)
        configUI(alertType)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAnimation() {
        self.containerView.center.y = bounds.height * 0.5 - 100
        containerView.alpha = 0
        coverBtn.alpha = 0
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.transitionCrossDissolve],
                       animations: {
                        self.coverBtn.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.7,
                       delay: 0.15,
                       usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3,
                       options: [.curveEaseInOut, .transitionCrossDissolve],
                       animations: {
                        self.containerView.center.y = self.bounds.height * 0.5
                        self.containerView.alpha = 1
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
    }
    
}

extension FXTutorialHandlerAlert {
    
    fileprivate func configUI(_ type: AlertType) {
        if let data = type.data, let iconURL = data.iconURL {
            let icon = UIImage(contentsOfFile: Bundle.getFilePath(fileName: iconURL))
            iconView.image =  icon
        }
        if let data = type.data, let title = data.title {
            titleLabel.text = title
        }
        if let data = type.data, let btnTitle = data.buttonTiitle, !btnTitle.isEmpty {
            okButton.setImage(nil, for: .normal)
            okButton.setTitle(btnTitle, for: .normal)
            okButton.imageEdgeInsets = .zero
        } else {
            okButton.setTitle(" " + "去看看".localized_FX(), for: .normal)
            let icon = UIImage(contentsOfFile: Bundle.getFilePath(fileName: "ic_tutorial_alter_contine@3x"))
            okButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
            okButton.setImage(icon, for: .normal)
        }
        let desc = type.data?.desc
        descLabel.text = desc
        let ylsHeight: CGFloat = 124.0.fitiPhone5sSerires
        let titleTop: CGFloat = 27.0.fitiPhone5sSerires
        let btnHeight: CGFloat = 38.0.fitiPhone5sSerires
        let iconTop: CGFloat = 10
        addSubview(coverBtn)
        coverBtn.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        addSubview(containerView)
        let contentHeight: CGFloat = ylsHeight - iconTop
        containerView.snp.makeConstraints {
            $0.left.equalTo(0)
            $0.right.equalTo(0)
            $0.center.equalTo(self.snp.center)
            $0.height.greaterThanOrEqualTo(contentHeight)
        }
        containerView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.right.equalTo(-29.0.fitiPhone5sSerires)
            $0.left.equalTo(41.0.fitiPhone5sSerires)
            $0.top.bottom.equalTo(0)
        }
        containerView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.equalTo(23.0.fitiPhone5sSerires)
            $0.width.equalTo(99.0.fitiPhone5sSerires)
            $0.height.equalTo(ylsHeight)
            $0.bottom.equalTo(contentView.snp.bottom).offset(0)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(titleTop)
            $0.left.equalTo(iconView.snp.right).offset(6.0.fitiPhone5sSerires)
            $0.height.equalTo(17.0.fitiPhone5sSerires)
        }
        contentView.addSubview(descLabel)
        descLabel.sizeToFit()
        descLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(-20.0.fitiPhone5sSerires)
            $0.top.equalTo(titleLabel.snp.bottom).offset(13.0.fitiPhone5sSerires)
            $0.bottom.equalTo(-40.0.fitiPhone5sSerires)
        }
        containerView.addSubview(okButton)
        okButton.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.bottom)
            $0.right.equalTo(contentView.snp.right).offset(-20.0.fitiPhone5sSerires)
            $0.height.equalTo(btnHeight)
            $0.width.equalTo(98.0.fitiPhone5sSerires)
        }
    }
    
    fileprivate func dismiss(_ callback: Bool, result: Any?, animate: Bool = true) {
        if animate {
            UIView.animate(withDuration: 0.7,
                           delay: 0,
                           options: [.curveEaseInOut, .transitionCrossDissolve],
                           animations: {
                            self.containerView.center.y = UIScreen.main.bounds.height * 2
                            self.coverBtn.alpha = 0
            }, completion: { _ in
                if callback {
                    self.dismissHandler?(result)
                }
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
    }
    
    @objc func okAction(_ sender: Any?) {
        dismiss(true, result: false, animate: true)
    }
    
    @objc
    fileprivate func coverBtnAction() {
        dismiss(true, result: false, animate: true)
    }
}

extension FXTutorialHandlerAlert: CAAnimationDelegate {
    
}


