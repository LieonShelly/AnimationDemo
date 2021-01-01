//
//  IFMyShareAlbumDetailQRView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit
import Photos

class IFMyShareAlbumDetailQRView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Medium", size: 22)
        label.textColor = UIColor(hex: 0x222222)
        label.text = "我的摄影作品集"
        label.textAlignment = .center
        return label
    }()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "PingFangSC-Regular", size: 12)
        label.textColor = UIColor(hex: 0xb5b5b5)
        label.text = "2020-12-08"
        label.textAlignment = .center
        return label
    }()
    lazy var codeLael: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Light", size: 13)
        label.textColor = UIColor.black
        label.text = "提取码：123456"
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor(hex: 0x333333)?.cgColor
        return label
    }()
    lazy var wechatBtn: UIButton = {
        let wechatBtn = UIButton()
        wechatBtn.setImage(UIImage(named: "ic_myshare_wechat"), for: .normal)
        return wechatBtn
    }()
    lazy var qrView: UIImageView = {
        let qrView = UIImageView()
        qrView.backgroundColor = .white
        return qrView
    }()
    lazy var qrBgView: UIImageView = {
        let qrView = UIImageView()
        qrView.backgroundColor = .white
        return qrView
    }()
    fileprivate lazy var bgView: FXGradientView = {
        let bgView = FXGradientView()
        let layer = bgView.layer as? CAGradientLayer
        layer?.colors = [UIColor(hex: 0xf7f6f4)!.cgColor, UIColor(hex: 0xf7f6f4)!.cgColor]
        layer?.startPoint = CGPoint(x: 0, y: 0)
        layer?.endPoint = CGPoint(x: 0, y: 1)
        return bgView
    }()
    fileprivate lazy var toptitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 11, isBold: true)
        label.textColor = UIColor(hex: 0xa38065)
        label.text = "·" + "支持高质量下载".localized(nil) + "·"
        return label
    }()
    fileprivate lazy var qrSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        var kern = 0
        if String.getLocLanguage() == "zh-Hans" {
            kern = 2
        }
        let attr0 = NSMutableAttributedString(string: "长按保存二维码图片".localized(nil))
        attr0.addAttributes([.font: UIFont(name: "PingFangSC-Regular", size: 13)!,
                             .foregroundColor: UIColor(hex: 0x222222)!,
                             .kern: kern],
                            range: NSRange(location: 0, length: attr0.string.count))
        attr0.append(NSAttributedString(string: " "))
        label.attributedText = attr0
        return label
    }()
  
    fileprivate lazy var wechatBtnLabel: UILabel = {
        let label = UILabel()
        let attr0 = NSMutableAttributedString(string: "分享给朋友".localized(nil))
        attr0.addAttributes([.font: UIFont(name: "PingFangSC-Regular", size: 11)!,
                             .foregroundColor: UIColor(hex: 0x333333)!,
                             .kern: 0],
                            range: NSRange(location: 0, length: attr0.string.count))
        label.attributedText = attr0
        return label
    }()
    fileprivate lazy var topBgView: FXGradientView = {
        let topBgView = FXGradientView()
        let layer = topBgView.layer as? CAGradientLayer
        layer?.colors = [UIColor(hex: 0xf2d9c7)!.cgColor, UIColor(hex: 0xd4ae95)!.cgColor]
        layer?.cornerRadius = 15
        layer?.startPoint = CGPoint(x: 0, y: 1)
        layer?.endPoint = CGPoint(x: 1, y: 1)
        layer?.masksToBounds = true
        return topBgView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        let topContainer = UIView()
        let titleTopInsetView = UIView()
        let qrTopInsetView = UIView()
        let codeTopInetView = UIView()
        let wechatTopInsetView = UIView()
        let wechatBottomInsetView = UIView()
    
        addSubview(titleTopInsetView)
        addSubview(topContainer)
        addSubview(titleTopInsetView)
        addSubview(qrTopInsetView)
        addSubview(codeTopInetView)
        addSubview(wechatTopInsetView)
        addSubview(wechatBottomInsetView)
        let titleContainer = UIView()
        addSubview(titleContainer)
        let qrContainer = UIView()
        addSubview(qrContainer)
        topContainer.isUserInteractionEnabled = false
        titleTopInsetView.isUserInteractionEnabled = false
        qrTopInsetView.isUserInteractionEnabled = false
        codeTopInetView.isUserInteractionEnabled = false
        wechatTopInsetView.isUserInteractionEnabled = false
        wechatBottomInsetView.isUserInteractionEnabled = false
        qrView.isUserInteractionEnabled = false
        qrBgView.isUserInteractionEnabled = false
        qrSubtitleLabel.isUserInteractionEnabled = false
        codeLael.isUserInteractionEnabled = false
        qrContainer.isUserInteractionEnabled = false
        titleLabel.isUserInteractionEnabled = false
        subtitleLabel.isUserInteractionEnabled = false
        titleContainer.isUserInteractionEnabled = false
        
        topContainer.addSubview(topBgView)
        topContainer.addSubview(toptitleLabel)
        topContainer.snp.makeConstraints {
            $0.left.top.right.equalTo(0)
            $0.height.equalTo(28)
        }
        toptitleLabel.snp.makeConstraints {
            $0.right.equalTo(-11)
            $0.top.equalTo(6)
        }
        topBgView.snp.makeConstraints {
            $0.right.equalTo(28 * 2)
            $0.height.equalTo(28 * 2)
            $0.left.equalTo(toptitleLabel.snp.left).offset(-11)
            $0.bottom.equalTo(toptitleLabel.snp.bottom).offset(6)
        }
        
        topContainer.snp.makeConstraints {
            $0.top.left.right.equalTo(0)
            $0.bottom.equalTo(topBgView.snp.bottom)
        }

      
        titleTopInsetView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(topContainer.snp.bottom)
            $0.bottom.equalTo(titleContainer.snp.top)
            $0.height.equalTo(qrTopInsetView.snp.height)
        }
        
        titleContainer.addSubview(titleLabel)
        titleContainer.addSubview(subtitleLabel)
        titleContainer.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(titleTopInsetView.snp.bottom)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
            $0.top.equalTo(0)
            $0.height.equalTo(30)
        }
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(titleLabel.snp.centerX)
            $0.top.equalTo(titleLabel.snp.bottom).offset(0)
            $0.height.equalTo(17)
            $0.bottom.equalTo(0)
        }


        qrTopInsetView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(titleContainer.snp.bottom)
            $0.bottom.equalTo(qrContainer.snp.top)
            $0.height.equalTo(codeTopInetView.snp.height)
        }
        qrContainer.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(qrTopInsetView.snp.bottom)
        }
        qrContainer.addSubview(qrBgView)
        qrContainer.addSubview(qrView)
        qrContainer.addSubview(qrSubtitleLabel)

        qrBgView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 194, height: 194))
            $0.top.equalTo(qrContainer.snp.top)
            $0.centerX.equalTo(titleLabel.snp.centerX)
        }
        qrView.snp.makeConstraints {
            $0.edges.equalTo(qrBgView.snp.edges).inset(11)
        }
        qrSubtitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(titleLabel.snp.centerX)
            $0.top.equalTo(qrBgView.snp.bottom).offset(9)
            $0.height.equalTo(18)
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
            $0.bottom.equalTo(qrContainer.snp.bottom)
        }
        addSubview(codeLael)

        codeTopInetView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(qrContainer.snp.bottom)
            $0.bottom.equalTo(codeLael.snp.top)
            $0.height.equalTo(wechatTopInsetView.snp.height)
        }

        codeLael.snp.makeConstraints {
            $0.centerX.equalTo(titleLabel.snp.centerX)
            $0.top.equalTo(codeTopInetView.snp.bottom)
            $0.size.equalTo(CGSize(width: 140, height: 30))
        }
        let wechatView = UIView()
        addSubview(wechatView)
        wechatView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(wechatTopInsetView.snp.bottom)
        }
        wechatTopInsetView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(codeLael.snp.bottom)
            $0.bottom.equalTo(wechatView.snp.top)
            $0.height.equalTo(wechatBottomInsetView.snp.height)
        }

        wechatView.addSubview(wechatBtn)
        wechatView.addSubview(wechatBtnLabel)
        wechatBtn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 63, height: 63))
            $0.left.right.equalTo(0)
            $0.top.equalTo(wechatView.snp.top)
            $0.centerX.equalTo(wechatView.snp.centerX)
        }
        wechatBtnLabel.snp.makeConstraints {
            $0.top.equalTo(wechatBtn.snp.bottom).offset(0)
            $0.centerX.equalTo(wechatBtn.snp.centerX)
            $0.bottom.equalTo(wechatView.snp.bottom)
        }

        let bottomView = UIView()
        addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(0)
            $0.height.equalTo(UIDevice.current.isiPhoneXSeries ? 15 : 5)
        }

        wechatBottomInsetView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(wechatView.snp.bottom)
            $0.bottom.equalTo(bottomView.snp.top)
            $0.height.equalTo(titleTopInsetView.snp.height)
        }
        let longges = UILongPressGestureRecognizer(target: self, action: #selector(self.saveQr(_:)))
        longges.minimumPressDuration = 1
        bgView.isUserInteractionEnabled = true
        bgView.addGestureRecognizer(longges)
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc
    fileprivate func saveQr(_ ges: UILongPressGestureRecognizer) {
        guard let image = qrView.image else {
//            FXViewToast.makeToast("保存失败，请重试".localized(nil))
            return
        }
        guard ges.state == .began else {
            return
        }
        let impactFeedBack = UIImpactFeedbackGenerator()
        impactFeedBack.prepare()
        impactFeedBack.impactOccurred()
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { (isSuccess, _) in
            DispatchQueue.main.async {
//                if isSuccess {
//                    self.makeToast("保存成功".localized(nil))
//                } else {
//                    self.makeToast("保存失败，请重试".localized(nil))
//                }
            }
        }
    }
}
