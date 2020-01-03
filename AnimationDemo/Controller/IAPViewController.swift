//
//  IAPViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/12/31.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import AVKit
import RxCocoa
import RxSwift

class IAPViewController: UIViewController {
    fileprivate let bag = DisposeBag()
    fileprivate lazy var bottomBg: UIImageView = {
        let bottomBg = UIImageView()
        return bottomBg
    }()
    fileprivate lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let btnImg = UIImage(contentsOfFile: Bundle.getFilePath(fileName: "iap_close@3x"))
        btn.setImage(btnImg, for: .normal)
        return btn
    }()
    fileprivate lazy var recoverVipBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("恢复会员".localized_FX(), for: .normal)
        btn.setTitleColor(.white, for: .normal)
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
    fileprivate lazy var playerContainer: SimpleVideoView = {
        let view = SimpleVideoView()
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
    fileprivate lazy var hook0: IFHookMarkView = IFHookMarkView(frame: CGRect(origin: .zero, size: CGSize(width: 12, height: 12)))
    fileprivate lazy var hook1: IFHookMarkView = IFHookMarkView(frame: CGRect(origin: .zero, size: CGSize(width: 12, height: 12)))
    fileprivate lazy var hook2: IFHookMarkView = IFHookMarkView(frame: CGRect(origin: .zero, size: CGSize(width: 12, height: 12)))
    fileprivate lazy var hook3: IFHookMarkView = IFHookMarkView(frame: CGRect(origin: .zero, size: CGSize(width: 12, height: 12)))
    fileprivate lazy var hook4: IFHookMarkView = IFHookMarkView(frame: CGRect(origin: .zero, size: CGSize(width: 12, height: 12)))
    fileprivate lazy var hook5: IFHookMarkView = IFHookMarkView(frame: CGRect(origin: .zero, size: CGSize(width: 12, height: 12)))
    fileprivate var h0: UIView!
    fileprivate var h1: UIView!
    fileprivate var h2: UIView!
    fileprivate var h3: UIView!
    fileprivate var h4: UIView!
    fileprivate var h5: UIView!
    
    fileprivate lazy var gradientView: FXGradientView = {
        let gradientView = FXGradientView()
        let gradientLayer = gradientView.layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor,
            UIColor.white.withAlphaComponent(0.7).cgColor,
            UIColor.white.withAlphaComponent(0.8).cgColor,
            UIColor.white.withAlphaComponent(0.9).cgColor,
            UIColor.white.cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 0.5)
        gradientLayer.locations = [0, 0.2, 0.4, 0.6, 0.8, 1]
        return gradientView
    }()
    
    fileprivate lazy var subscribeBtn: FXBtnView = {
        let view = FXBtnView()
        let text0 = "立即订阅"
        let text1 = "￥218"
        let text2 = " / "
        let text3 = "年"
        let textColor = UIColor(hex: 0xc77fe6)!
        let text0Font = UIFont.customFont(ofSize: 16.0.fitiPhone5sSerires, isBold: true)
        let text1Font = UIFont.customFont(ofSize: 12.0.fitiPhone5sSerires, isBold: true)
        let text2Font = UIFont.customFont(ofSize: 8.0.fitiPhone5sSerires, isBold: true)
        let text3Font = UIFont.customFont(ofSize: 12.0.fitiPhone5sSerires, isBold: true)
        let verticalStyle = NSMutableParagraphStyle()
        verticalStyle.lineSpacing = 5.0.fitiPhone5sSerires
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
        view.layer.cornerRadius = 10.0.fitiPhone5sSerires
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
        let text0Font = UIFont.customFont(ofSize: 16.0.fitiPhone5sSerires, isBold: true)
        let text1Font = UIFont.customFont(ofSize: 12.0.fitiPhone5sSerires, isBold: true)
        let text2Font = UIFont.customFont(ofSize: 8.0.fitiPhone5sSerires, isBold: true)
        let text3Font = UIFont.customFont(ofSize: 12.0.fitiPhone5sSerires, isBold: true)
        let verticalStyle = NSMutableParagraphStyle()
        verticalStyle.lineSpacing = 5.0.fitiPhone5sSerires
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
        view.setTitle(.double(attr0, attr4), isSelected: true)
        //        view.setTitle(.sigle(attr5))
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerContainer.startPlay()
        showAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        playerContainer.endPlay()
        super.viewWillDisappear(animated)
    }
    
    
}

extension IAPViewController {
    
    fileprivate func configUI() {
        view.backgroundColor = .white
        let commonTop: CGFloat = UIDevice.current.isiPhoneXSeries ? 38: 0
        if let videoFile = Bundle.main.path(forResource: UIDevice.current.isiPhoneXSeries ? "video_vip_headerView_x" : "video_vip_headerView_plus",
                                            ofType: "mp4") {
            let videoURL = URL(fileURLWithPath: videoFile)
            playerContainer.loadUrl(url: videoURL)
            let asset = AVAsset(url: videoURL)
            let tracks = asset.tracks
            var videoSize = CGSize(width: 0, height: 1)
            for track in tracks {
                videoSize = track.naturalSize
            }
            view.addSubview(playerContainer)
            playerContainer.snp.makeConstraints {
                $0.left.top.right.equalTo(0)
                let height = view.bounds.width * videoSize.height / videoSize.width
                $0.height.equalTo(height + (UIDevice.current.isiPhoneXSeries ? 88.0.fitiPhone5sSerires : 0))
            }
        }
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(commonTop + 20.0.fitiPhone5sSerires)
            $0.height.equalTo(44.0.fitiPhone5sSerires)
        }
        
        topView.addSubview(closeBtn)
        topView.addSubview(recoverVipBtn)
        closeBtn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 32.0.fitiPhone5sSerires, height: 32.0.fitiPhone5sSerires))
            $0.centerY.equalTo(topView.snp.centerY)
            $0.left.equalTo(12.0.fitiPhone5sSerires)
        }
        recoverVipBtn.snp.makeConstraints {
            $0.right.equalTo(-16.0.fitiPhone5sSerires)
            $0.centerY.equalTo(topView.snp.centerY)
        }
        
        let tileHeight: CGFloat = 33.0.fitiPhone5sSerires
        let subTitleHeight: CGFloat = 22.0.fitiPhone5sSerires
        let titleInset: CGFloat = 14.0.fitiPhone5sSerires
        var titleViewTop: CGFloat = 56.0.fitiPhone5sSerires
        if UIDevice.current.isBelowOrEqual375Device {
            titleViewTop = 41.0.fitBelow375Pt
        }
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(topView.snp.bottom).offset(titleViewTop)
            $0.height.equalTo(tileHeight + subTitleHeight + titleInset)
        }
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(36.0.fitiPhone5sSerires)
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
        let bottonImg = UIImage(named: "ipa_bottom_bg")
        bottomBg.image = bottonImg
        let privacyViewHeight: CGFloat = bottonImg!.size.height
        view.addSubview(privacyBtnView)
        privacyBtnView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
            $0.height.equalTo(privacyViewHeight)
        }
        privacyBtnView.addSubview(bottomBg)
        bottomBg.snp.makeConstraints {
            $0.size.equalTo(bottonImg!.size)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(0)
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
        let subcribeBtnHeight: CGFloat = 52.0.fitiPhone5sSerires
        let subscribeInset: CGFloat = 10.0.fitiPhone5sSerires
        view.addSubview(iapBtnView)
        iapBtnView.addSubview(subscribeBtn)
        subscribeBtn.snp.makeConstraints {
            $0.left.equalTo(33.0.fitiPhone5sSerires)
            $0.right.equalTo(-33.0.fitiPhone5sSerires)
            $0.top.equalTo(0)
            $0.height.equalTo(subcribeBtnHeight)
        }
        iapBtnView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.bottom.equalTo(privacyBtnView.snp.top).offset(-11.0.fitiPhone5sSerires)
            $0.height.equalTo(subcribeBtnHeight * 2 + subscribeInset)
        }
        iapBtnView.addSubview(tryBtn)
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
        
        let textMaxWidth: CGFloat = view.bounds.width - 60.0.fitiPhone5sSerires
        let attr0 = createBlackAttrText("会员专属图标")
        descLabel0.attributedText = attr0.attriText
        descLabel0.frame.size = CGSize(width: textMaxWidth, height: attr0.textHeight)
        
        let attr1 = createBlackAttrText("最新功能抢先体验")
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
        h0 = createHorisionStack(hook0, label: descLabel0)
        h1 = createHorisionStack(hook1, label: descLabel1)
        h2 = createHorisionStack(hook2, label: descLabel2)
        h3 = createHorisionStack(hook3, label: descLabel3)
        h4 = createHorisionStack(hook4, label: descLabel4)
        h5 = createHorisionStack(hook5, label: descLabel5)
        
        descLabelView.addSubview(h0)
        descLabelView.addSubview(h1)
        descLabelView.addSubview(h2)
        descLabelView.addSubview(h3)
        descLabelView.addSubview(h4)
        descLabelView.addSubview(h0)
        descLabelView.addSubview(h5)
        
        let hStackHeight: CGFloat = 28.0.fitiPhone5sSerires
        let hStackInset: CGFloat = 15.0.fitBelow375Pt
        var hoTop: CGFloat = 68.0.fitiPhone5sSerires
        if UIDevice.current.isBelowOrEqual375Device {
            hoTop = 40.0.fitBelow375Pt
        }
        h0.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.top.equalToSuperview().offset(hoTop)
            $0.width.equalToSuperview()
            $0.height.equalTo(hStackHeight)
        }
        h1.snp.makeConstraints {
            $0.left.equalTo(h0.snp.left)
            $0.top.equalTo(h0.snp.bottom).offset(hStackInset)
            $0.width.equalToSuperview()
            $0.height.equalTo(hStackHeight)
        }
        
        h2.snp.makeConstraints {
            $0.left.equalTo(h0.snp.left)
            $0.top.equalTo(h1.snp.bottom).offset(hStackInset)
            $0.width.equalToSuperview()
            $0.height.equalTo(hStackHeight)
        }
        
        h3.snp.makeConstraints {
            $0.left.equalTo(h0.snp.left)
            $0.top.equalTo(h2.snp.bottom).offset(hStackInset)
            $0.width.equalToSuperview()
            $0.height.equalTo(hStackHeight)
        }
        
        h4.snp.makeConstraints {
            $0.left.equalTo(h0.snp.left)
            $0.top.equalTo(h3.snp.bottom).offset(hStackInset)
            $0.width.equalToSuperview()
            $0.height.equalTo(hStackHeight)
        }
        
        h5.snp.makeConstraints {
            $0.left.equalTo(h0.snp.left)
            $0.top.equalTo(h4.snp.bottom).offset(hStackInset)
            $0.width.equalToSuperview()
            $0.height.equalTo(hStackHeight)
        }
        
        view.insertSubview(gradientView, aboveSubview: playerContainer)
        gradientView.snp.makeConstraints {
            $0.left.right.top.equalTo(0)
            $0.bottom.equalTo(descLabelView.snp.bottom)
        }
        
        closeBtn.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
        
        view.layoutIfNeeded()
    }
    
    fileprivate func createBlackTextStyle() -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: UIFont.customFont(ofSize: 14.0.fitiPhone5sSerires, isBold: true),
            NSAttributedString.Key.foregroundColor: UIColor(hex: 0x101010)!,
        ]
    }
    
    fileprivate func createHightLightTextStyle() -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: UIFont.customFont(ofSize: 20.0.fitiPhone5sSerires, isBold: true),
            NSAttributedString.Key.foregroundColor: UIColor(hex: 0xc77fe6)!,
        ]
    }
    
    fileprivate func createHorisionStack(_ hookView: UIView, label: UILabel) -> UIView {
        let horisionStack = UIView()
        horisionStack.addSubview(hookView)
        horisionStack.addSubview(label)
        hookView.snp.makeConstraints {
            $0.left.equalTo(0)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 12.0.fitiPhone5sSerires, height: 12.0.fitiPhone5sSerires))
        }
        label.snp.makeConstraints {
            $0.left.equalTo(hookView.snp.right).offset(12.0.fitiPhone5sSerires)
            $0.centerY.equalToSuperview()
        }
        return horisionStack
    }
    
    fileprivate func createVerticalStack() -> UIStackView {
        let horisionStack = UIStackView()
        horisionStack.axis = .vertical
        horisionStack.spacing = 20.0.fitiPhone5sSerires
        horisionStack.alignment = .leading
        return horisionStack
    }
    
    fileprivate func createBlackAttrText(_ inputext: String) -> (attriText: NSMutableAttributedString, textHeight: CGFloat) {
        let textMaxWidth: CGFloat = view.bounds.width - 60.0.fitiPhone5sSerires
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
        let textMaxWidth: CGFloat = view.bounds.width - 60.0.fitiPhone5sSerires
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
    
    fileprivate func showAnimation() {
        let h0Y = h0.frame.origin.y
        let h0AnimateStartY: CGFloat = h0Y + 100
        h0.frame.origin.y = h0AnimateStartY
        h0.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.h0.frame.origin.y = h0Y
        }, completion: nil)
        
        let h1Y = h1.frame.origin.y
        let h1AnimateStartY: CGFloat =  h1Y + 140
        h1.frame.origin.y = h1AnimateStartY
        h1.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.h1.frame.origin.y = h1Y
        }, completion: nil)
        
        let h2Y = h2.frame.origin.y
        let h2AnimateStartY: CGFloat = h2Y + 180
        h2.frame.origin.y = h2AnimateStartY
        h2.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.h2.frame.origin.y = h2Y
        }, completion: nil)
        
        let h3Y = h3.frame.origin.y
        let h3AnimateStartY: CGFloat = h3Y + 220
        h3.frame.origin.y = h3AnimateStartY
        h3.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.h3.frame.origin.y = h3Y
        }, completion: nil)
        
        let h4Y = h4.frame.origin.y
        let h4AnimateStartY: CGFloat = h4Y + 260
        h4.frame.origin.y = h4AnimateStartY
        h4.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.h4.frame.origin.y = h4Y
        }, completion: nil)
        
        let h5Y = h5.frame.origin.y
        let h5AnimateStartY: CGFloat = h5Y + 300
        h5.frame.origin.y = h5AnimateStartY
        h5.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.h5.frame.origin.y = h5Y
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveEaseInOut], animations: {
            self.h0.alpha = 1
            self.h1.alpha = 1
            self.h2.alpha = 1
            self.h3.alpha = 1
            self.h4.alpha = 1
            self.h5.alpha = 1
        }, completion: nil)
    
        privacyBtn.alpha = 0.8
        conditionBtn.alpha = 0.8
        UIView.animate(withDuration: 0.25, delay: 1, options: [.curveEaseInOut], animations: {
            self.privacyBtn.alpha = 1
            self.conditionBtn.alpha = 1
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.hook0.showAnimation()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 + 0.25) {
            self.hook1.showAnimation()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 + 0.25 * 2) {
            self.hook2.showAnimation()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 + 0.25 * 3) {
            self.hook3.showAnimation()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 + 0.25 * 4) {
            self.hook4.showAnimation()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 + 0.25 * 5) {
            self.hook5.showAnimation()
        }
        
        subscribeBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        tryBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        tryBtn.alpha = 0
        subscribeBtn.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 1 + 0.25 * 5, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [.curveEaseInOut], animations: {
            self.subscribeBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, delay: 1 + 0.25 * 5, options: [.curveEaseInOut], animations: {
            self.subscribeBtn.alpha = 1
        }, completion: nil)
               
        UIView.animate(withDuration: 1, delay: 1 + 0.25 * 5 + 0.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [.curveEaseInOut], animations: {
            self.tryBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)

        UIView.animate(withDuration: 0.25, delay: 1 + 0.25 * 5 + 0.8, options: [.curveEaseInOut], animations: {
            self.tryBtn.alpha = 1
        }, completion: nil)
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


extension Double {
    /// 适配375pt以下的机型
    var fitBelow375Pt: CGFloat {
        let deviceWidth = UIScreen.main.bounds.width
        let standwardWdith: CGFloat = 375.0
        if deviceWidth <= standwardWdith {
           return  CGFloat(self) * UIScreen.main.bounds.width / standwardWdith
        }
        return CGFloat(self)
    }

}



extension String {
    func localized_FX() -> String {
        return self
    }
}
