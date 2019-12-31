//
//  IAPViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/12/31.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class IAPViewController: UIViewController {
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .yellow
        return btn
    }()
    fileprivate lazy var recoverVipBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("恢复会员".localized_FX(), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.titleLabel?.font = UIFont.customFont(ofSize: 15, isBold: true)
        return btn
    }()
    fileprivate lazy var topView: UIView = {
        let topView = UIView()
        return topView
    }()
    fileprivate lazy var titleView: UIView = {
        let topView = UIView()
        return topView
    }()
    fileprivate lazy var descLabelView: UIView = {
        let topView = UIView()
        return topView
    }()
    fileprivate lazy var playerContainer: UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var iapBtnView: UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var privacyBtnView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text  = "升级 inFace VIP".localized_FX()
        label.font = UIFont.customFont(ofSize: 24, isBold: true)
        label.textColor = .black
        return label
    }()
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text  = "尽情享受全部功能与素材".localized_FX()
        label.font = UIFont.customFont(ofSize: 16, isBold: false)
        label.textColor = UIColor(hex: 0x808080)
        return label
    }()
    fileprivate lazy var descLabel0: UILabel = {
        let label = UILabel()
        return label
    }()
    fileprivate lazy var descLabel1: UILabel = {
        let label = UILabel()
        return label
    }()
    fileprivate lazy var descLabel2: UILabel = {
        let label = UILabel()
        return label
    }()
    fileprivate lazy var descLabel3: UILabel = {
        let label = UILabel()
        return label
    }()
    fileprivate lazy var descLabel4: UILabel = {
        let label = UILabel()
        return label
    }()
    fileprivate lazy var descLabel5: UILabel = {
        let label = UILabel()
        return label
    }()
    
    fileprivate lazy var subscribeBtn: FXBtnView = {
        let view = FXBtnView()
        let text0 = "立即订阅"
        let text1 = "￥218"
        let text2 = " / "
        let text3 = "年"
        let textColor = UIColor(hex: 0xc77fe6)!
        let text0Font = UIFont.customFont(ofSize: 16, isBold: true)
        let text1Font = UIFont.customFont(ofSize: 12, isBold: true)
        let text2Font = UIFont.customFont(ofSize: 8, isBold: true)
        let text3Font = UIFont.customFont(ofSize: 12, isBold: true)
        let verticalStyle = NSMutableParagraphStyle()
        verticalStyle.lineSpacing = 5
        verticalStyle.alignment = .center
        
        let attr0 = NSMutableAttributedString()
        attr0.append(NSAttributedString(string: text0,
                                        attributes: [
                                            NSAttributedString.Key.foregroundColor : textColor,
                                            NSAttributedString.Key.font : text0Font,
        ]))
        
        let attr1 = NSMutableAttributedString(string: text1,
                                              attributes: [
                                                NSAttributedString.Key.foregroundColor : textColor,
                                                NSAttributedString.Key.font : text1Font,
        ])
        let attr2 = NSMutableAttributedString(string: text2,
                                              attributes: [
                                                NSAttributedString.Key.foregroundColor : textColor,
                                                NSAttributedString.Key.font : text2Font,
        ])
        let attr3 = NSMutableAttributedString(string: text3,
                                              attributes: [
                                                NSAttributedString.Key.foregroundColor : textColor,
                                                NSAttributedString.Key.font : text3Font,
        ])
        
        let attr4 = NSMutableAttributedString()
        attr4.append(attr1)
        attr4.append(attr2)
        attr4.append(attr3)
        
        view.setTitle(.double(attr0, attr4), isSelected: false)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    fileprivate lazy var tryBtn: FXBtnView = {
        let view = FXBtnView()
        let text0 = "开始试用"
        let text1 = "免费试用3天，然后￥218"
        let text2 = " / "
        let text3 = "年"
        let textColor = UIColor.white
        let text0Font = UIFont.customFont(ofSize: 16, isBold: true)
        let text1Font = UIFont.customFont(ofSize: 12, isBold: true)
        let text2Font = UIFont.customFont(ofSize: 8, isBold: true)
        let text3Font = UIFont.customFont(ofSize: 12, isBold: true)
        let verticalStyle = NSMutableParagraphStyle()
        verticalStyle.lineSpacing = 5
        verticalStyle.alignment = .center
        
        let attr0 = NSMutableAttributedString()
        attr0.append(NSAttributedString(string: text0,
                                        attributes: [
                                            NSAttributedString.Key.foregroundColor : textColor,
                                            NSAttributedString.Key.font : text0Font,
        ]))
        
        let attr1 = NSMutableAttributedString(string: text1,
                                              attributes: [
                                                NSAttributedString.Key.foregroundColor : textColor,
                                                NSAttributedString.Key.font : text1Font,
        ])
        let attr2 = NSMutableAttributedString(string: text2,
                                              attributes: [
                                                NSAttributedString.Key.foregroundColor : textColor,
                                                NSAttributedString.Key.font : text2Font,
        ])
        let attr3 = NSMutableAttributedString(string: text3,
                                              attributes: [
                                                NSAttributedString.Key.foregroundColor : textColor,
                                                NSAttributedString.Key.font : text3Font,
        ])
        
        let attr4 = NSMutableAttributedString()
        attr4.append(attr1)
        attr4.append(attr2)
        attr4.append(attr3)
        
        let text5 = "还不确定？开启免费试用版"
        let attr5 = NSMutableAttributedString(string: text5)
        attr5.addAttributes([
            NSAttributedString.Key.font : UIFont.customFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor(hex: 0xc77fe6)!,
            ],
                            range: NSRange(location: 0, length: text5.count))
//        view.setTitle(.double(attr0, attr4), isSelected: true)
        view.setTitle(.sigle(attr5))
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var conditionBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(UIColor(hex: 0x808080), for: .normal)
        btn.setTitle("使用条款".localized_FX(), for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 11, isBold: true)
        return btn
    }()
    fileprivate lazy var privacyBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(UIColor(hex: 0x808080), for: .normal)
        btn.setTitle("隐私政策".localized_FX(), for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 11, isBold: true)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
}

extension IAPViewController {
    
    fileprivate func configUI() {
        view.backgroundColor = .white
        let commonTop: CGFloat = UIDevice.current.isiPhoneXSeries ? 38: 0
        view.addSubview(playerContainer)
        playerContainer.snp.makeConstraints {
            $0.left.top.right.equalTo(0)
            // FIXME: 播放器的高度需要适配，根据视频来
            $0.height.equalTo(250)
        }
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(commonTop + 20)
            $0.height.equalTo(44)
        }
        
        topView.addSubview(closeBtn)
        topView.addSubview(recoverVipBtn)
        closeBtn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 32, height: 32))
            $0.centerY.equalTo(topView.snp.centerY)
            $0.left.equalTo(12)
        }
        recoverVipBtn.snp.makeConstraints {
            $0.right.equalTo(-16)
            $0.centerY.equalTo(topView.snp.centerY)
        }
        
        let tileHeight: CGFloat = 33
        let subTitleHeight: CGFloat = 22
        let titleInset: CGFloat = 14
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            // FIXME:适配机型，可能需要按机型来调整间距
            $0.top.equalTo(topView.snp.bottom).offset(41)
            $0.height.equalTo(tileHeight + subTitleHeight + titleInset)
        }
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(36)
            $0.right.equalTo(0)
            $0.top.equalTo(0)
            $0.height.equalTo(tileHeight)
        }
        subtitleLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
            $0.height.equalTo(subTitleHeight)
            $0.top.equalTo(titleLabel.snp.bottom).offset(titleInset)
        }
        
        /// 隐私协议
        let privacyViewHeight: CGFloat = 16 + 99
        view.addSubview(privacyBtnView)
        privacyBtnView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
            $0.height.equalTo(privacyViewHeight)
        }
        let bottomCenterLine = UIView()
        let bottomViewHeight: CGFloat = 15
        bottomCenterLine.backgroundColor = UIColor(hex: 0x808080)
        privacyBtnView.addSubview(bottomCenterLine)
        bottomCenterLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(10)
            $0.top.equalTo(10)
            $0.centerX.equalTo(privacyBtnView.snp.centerX)
        }
        privacyBtnView.addSubview(conditionBtn)
        privacyBtnView.addSubview(privacyBtn)
        conditionBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomCenterLine.snp.centerY)
            $0.right.equalTo(bottomCenterLine.snp.left).offset(-10.5)
            $0.height.equalTo(bottomViewHeight)
        }
        privacyBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomCenterLine.snp.centerY)
            $0.left.equalTo(bottomCenterLine.snp.right).offset(10.5)
            $0.height.equalTo(bottomViewHeight)
        }
        
        /// 订阅按钮部分
        let subcribeBtnHeight: CGFloat = 52
        let subscribeInset: CGFloat = 10
        view.addSubview(iapBtnView)
        iapBtnView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.bottom.equalTo(privacyBtnView.snp.top).offset(-11)
            $0.height.equalTo(subcribeBtnHeight * 2 + subscribeInset)
        }
        iapBtnView.addSubview(subscribeBtn)
        iapBtnView.addSubview(tryBtn)
        subscribeBtn.snp.makeConstraints {
            $0.left.equalTo(33)
            $0.right.equalTo(-33)
            $0.top.equalTo(0)
            $0.height.equalTo(subcribeBtnHeight)
        }
        tryBtn.snp.makeConstraints {
            $0.left.equalTo(subscribeBtn.snp.left)
            $0.right.equalTo(subscribeBtn.snp.right)
            $0.height.equalTo(subcribeBtnHeight)
            $0.top.equalTo(subscribeBtn.snp.bottom).offset(subscribeInset)
        }
        view.addSubview(descLabelView)
        descLabelView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(titleView.snp.bottom)
            $0.bottom.equalTo(iapBtnView.snp.top)
        }
        
        let textMaxWidth: CGFloat = view.bounds.width - 60
        let attr0 = createBlackAttrText("会员专属图标")
        descLabel0.attributedText = attr0.attriText
        descLabel0.frame.size = CGSize(width: textMaxWidth, height: attr0.textHeight)
        
        let attr1 = createBlackAttrText("会员专属图标")
        descLabel1.attributedText = attr1.attriText
        descLabel1.frame.size = CGSize(width: textMaxWidth, height: attr1.textHeight)
        
        let attr2 = createMulitiText("项高级调色功能", hightLoghtText: "22 ", fullText: "22 项高级调色功能")
        descLabel2.attributedText = attr2.attriText
        descLabel2.frame.size = CGSize(width: textMaxWidth, height: attr2.textHeight)
        
        let attr3 = createMulitiText("专业人像精修工具", hightLoghtText: "100+ ", fullText: "100+ 专业人像精修工具")
        descLabel3.attributedText = attr3.attriText
        descLabel3.frame.size = CGSize(width: textMaxWidth, height: attr3.textHeight)
        
        let attr4 = createMulitiText("顶级风格化滤镜全部解锁", hightLoghtText: "200+ ", fullText: "200+ 顶级风格化滤镜全部解锁")
        descLabel4.attributedText = attr4.attriText
        descLabel4.frame.size = CGSize(width: textMaxWidth, height: attr4.textHeight)
        
        let attr5 = createMulitiText("潮流创意素材，每周更新", hightLoghtText: "1000+ ", fullText: "1000+ 潮流创意素材，每周更新")
        descLabel5.attributedText = attr5.attriText
        descLabel5.frame.size = CGSize(width: textMaxWidth, height: attr5.textHeight)
        
        let h0 = createHorisionStack()
        h0.addArrangedSubview(descLabel0)
        let h1 = createHorisionStack()
        h1.addArrangedSubview(descLabel1)
        let h2 = createHorisionStack()
        h2.addArrangedSubview(descLabel2)
        let h3 = createHorisionStack()
        h3.addArrangedSubview(descLabel3)
        let h4 = createHorisionStack()
        h4.addArrangedSubview(descLabel4)
        let h5 = createHorisionStack()
        h5.addArrangedSubview(descLabel5)
        
        let vstack = createVerticalStack()
        vstack.addArrangedSubview(h0)
        vstack.addArrangedSubview(h1)
        vstack.addArrangedSubview(h2)
        vstack.addArrangedSubview(h3)
        vstack.addArrangedSubview(h4)
        vstack.addArrangedSubview(h5)
        descLabelView.addSubview(vstack)
        vstack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(36)
        }
    }
    
    fileprivate func createBlackTextStyle() -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: UIFont.customFont(ofSize: 14, isBold: true),
            NSAttributedString.Key.foregroundColor: UIColor(hex: 0x101010)!,
        ]
    }
    
    fileprivate func createHightLightTextStyle() -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: UIFont.customFont(ofSize: 20, isBold: true),
            NSAttributedString.Key.foregroundColor: UIColor(hex: 0xc77fe6)!,
        ]
    }
    
    fileprivate func createHorisionStack() -> UIStackView {
        let horisionStack = UIStackView()
        horisionStack.axis = .horizontal
        horisionStack.spacing = 12
        horisionStack.alignment = .leading
        return horisionStack
    }
    
    fileprivate func createVerticalStack() -> UIStackView {
        let horisionStack = UIStackView()
        horisionStack.axis = .vertical
        horisionStack.spacing = 20
        horisionStack.alignment = .leading
        return horisionStack
    }
    
    fileprivate func createBlackAttrText(_ inputext: String) -> (attriText: NSMutableAttributedString, textHeight: CGFloat) {
        let textMaxWidth: CGFloat = view.bounds.width - 60
        let text0 = inputext.localized_FX()
        let attrText0 = NSMutableAttributedString(string: text0)
        attrText0.addAttributes(createBlackTextStyle(),
                                range: NSRange(location: 0, length: text0.count))
        let attrText0Height: CGFloat = attrText0.boundingRect(with: CGSize(width: textMaxWidth, height: .infinity), options: NSStringDrawingOptions.usesFontLeading, context: nil).size.height
        return (attrText0, attrText0Height)
    }
    
    fileprivate func createMulitiText(_ blackText: String,
                                      hightLoghtText: String,
                                      fullText: String ) -> (attriText: NSMutableAttributedString, textHeight: CGFloat) {
        let textMaxWidth: CGFloat = view.bounds.width - 60
        let text2 = fullText.localized_FX()
        let text20 = hightLoghtText.localized_FX()
        let text21 = blackText.localized_FX()
        let attrText2 = NSMutableAttributedString(string: text2)
        attrText2.addAttributes(createHightLightTextStyle(),
                                range: NSRange(text2.range(of: text20)!, in: text2))
        attrText2.addAttributes(createBlackTextStyle(),
                                range: NSRange(text2.range(of: text21)!, in: text2))
        let attrText2Height: CGFloat = attrText2.boundingRect(with: CGSize(width: textMaxWidth, height: .infinity), options: NSStringDrawingOptions.usesFontLeading, context: nil).size.height
        return (attrText2, attrText2Height)
    }
    
    
    
    class FXBtnView: UIView {
        class FXHandleBtn: UIButton {
            var beginAction: (() -> Void)?
            var moveAction: (() -> Void)?
            var tochEndAction: (() -> Void)?
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesBegan(touches, with: event)
                beginAction?()
            }
            
            override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesMoved(touches, with: event)
                moveAction?()
            }
            
            override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesEnded(touches, with: event)
                tochEndAction?()
            }
        }
        enum TitleState {
            case sigle(NSMutableAttributedString)
            case double(NSMutableAttributedString, NSMutableAttributedString)
        }
        fileprivate var title: TitleState?
        fileprivate var isSelected: Bool = true
        fileprivate lazy var btn: FXHandleBtn = {
            let btn = FXHandleBtn(type: .system)
            return btn
        }()
        /// 有两行文字时使用
        fileprivate lazy var descLabel0: UILabel = {
            let label = UILabel()
            return label
        }()
        fileprivate lazy var descLabel1: UILabel = {
            let label = UILabel()
            return label
        }()
        /// 居中使用
        fileprivate lazy var descLabel2: UILabel = {
            let label = UILabel()
            return label
        }()
        
        fileprivate lazy var stackView: UIView = {
            let stack = UIView()
            stack.isUserInteractionEnabled = false
            return stack
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(btn)
            addSubview(stackView)
            stackView.addSubview(descLabel1)
            stackView.addSubview(descLabel0)
            btn.beginAction = {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.setLabelTextColor(.touchDown)
                
            }
            btn.tochEndAction = {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.setLabelTextColor(.touchUpInside)
            }
        }
        
        @objc
        fileprivate func btnAction(_ btn: UIButton) {
            
            
            
        }
        
        fileprivate func setLabelTextColor(_ state: UIControl.Event) {
            guard let title = self.title else {
                return
            }
            switch title {
            case .sigle:
                break
            case .double:
                switch state {
                case .touchDown:
                    descLabel1.alpha = 0.2
                    descLabel0.alpha = 0.2
                default:
                    descLabel1.alpha = 1
                    descLabel0.alpha = 1
                }
            }
        }
        
        func setTitle(_ title: TitleState,
                      isSelected: Bool = false) {
            self.title = title
            self.isSelected = isSelected
            setNeedsLayout()
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            btn.frame = bounds
            if isSelected {
                let gradientColors = [UIColor(hex: 0x7AD3FF)!, UIColor(hex: 0xE261DD)!]
                let gradientLayer: CAGradientLayer = CAGradientLayer.init()
                gradientLayer.frame = bounds
                gradientLayer.colors = gradientColors.map{ $0.cgColor }
                gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
                btn.setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .normal)
                gradientLayer.opacity = 0.5
                btn.setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .highlighted)
                gradientLayer.opacity = 0.2
                btn.setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .disabled)
            } else {
                let bgLayer = CALayer()
                bgLayer.backgroundColor = UIColor(hex: 0xb372ff)?.withAlphaComponent(0.1).cgColor
                bgLayer.frame = bounds
                btn.setBackgroundImage(UIImage.imageFrom(layer: bgLayer), for: .normal)
                btn.setTitleColor(UIColor(hex: 0xc77fe6), for: .normal)
            }
            guard let title = self.title else {
                return
            }
            switch title {
            case .sigle(let attrtitle):
                btn.setAttributedTitle(attrtitle, for: .normal)
                descLabel0.isHidden = true
                descLabel1.isHidden = true
            case .double(let attTitle0, let attTitle1):
                let labelInset: CGFloat = 3
                descLabel0.isHidden = false
                descLabel1.isHidden = false
                descLabel0.attributedText = attTitle0
                descLabel1.attributedText = attTitle1
                let testSize0 = attTitle0.boundingRect(with: CGSize(width: bounds.width, height: .infinity),
                                                       options: .usesFontLeading, context: nil).size
                let testSize1 = attTitle1.boundingRect(with: CGSize(width: bounds.width, height: .infinity),
                                                       options: .usesFontLeading, context: nil).size
                descLabel0.frame.size = testSize0
                descLabel1.frame.size = testSize1
                stackView.frame.size = CGSize(width: bounds.width, height: testSize0.height + testSize1.height + labelInset)
                stackView.center = CGPoint(x: bounds.midX, y: bounds.midY)
                descLabel0.frame.origin = CGPoint(x: stackView.bounds.width * 0.5 - testSize0.width * 0.5, y: 0)
                descLabel1.frame.origin = CGPoint(x: stackView.bounds.width * 0.5 - testSize1.width * 0.5, y: descLabel0.frame.maxY + labelInset)
            }
        }
        
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}



extension String {
    func localized_FX() -> String {
        return self
    }
}
