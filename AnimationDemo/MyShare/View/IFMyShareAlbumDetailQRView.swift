//
//  IFMyShareAlbumDetailQRView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/22.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFMyShareAlbumDetailQRView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 22, isBold: true)
        label.textColor = UIColor(hex: 0x222222)
        label.text = "我的摄影作品集"
        return label
    }()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 12)
        label.textColor = UIColor(hex: 0xb5b5b5)
        label.text = "2020-12-08"
        return label
    }()
    lazy var codeLael: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 13)
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
    fileprivate lazy var bgView: FXGradientView = {
        let bgView = FXGradientView()
        let layer = bgView.layer as? CAGradientLayer
        layer?.colors = [UIColor(hex: 0xf7f6f4)!.cgColor, UIColor(hex: 0xf7f6f4)!.cgColor]
        layer?.startPoint = CGPoint(x: 0.5, y: 0)
        layer?.endPoint = CGPoint(x: 0.5, y: 1)
        return bgView
    }()
    fileprivate lazy var toptitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 11)
        label.textColor = UIColor(hex: 0xa38065)
        label.text = "·支持高质量下载·"
        return label
    }()
    fileprivate lazy var qrSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 13)
        label.textColor = UIColor(hex: 0x222222)
        label.text = "扫码查看高清大图"
        return label
    }()
  
    fileprivate lazy var wechatBtnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 11)
        label.textColor = UIColor(hex: 0x333333)
        label.text = "分享给朋友"
        return label
    }()
    fileprivate lazy var topBgView: FXGradientView = {
        let topBgView = FXGradientView()
        let layer = topBgView.layer as? CAGradientLayer
        layer?.colors = [UIColor(hex: 0xf2d9c7)!.cgColor, UIColor(hex: 0xd4ae95)!.cgColor]
        layer?.cornerRadius = 15
        layer?.startPoint = CGPoint(x: 0, y: 0.5)
        layer?.endPoint = CGPoint(x: 1, y: 0.5)
        layer?.masksToBounds = true
        return topBgView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(bgView)
        addSubview(topBgView)
        addSubview(toptitleLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(qrView)
        addSubview(qrView)
        addSubview(qrSubtitleLabel)
        addSubview(codeLael)
        addSubview(wechatBtn)
        addSubview(wechatBtnLabel)
        bgView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        toptitleLabel.snp.makeConstraints {
            $0.right.equalTo(-11)
            $0.top.equalTo(6)
        }
        topBgView.snp.makeConstraints {
            $0.right.equalTo(100)
            $0.height.equalTo(100)
            $0.left.equalTo(toptitleLabel.snp.left).offset(-11)
            $0.bottom.equalTo(toptitleLabel.snp.bottom).offset(6)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(50)
            $0.height.equalTo(30)
        }
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(titleLabel.snp.centerX)
            $0.top.equalTo(titleLabel.snp.bottom).offset(0)
            $0.height.equalTo(17)
        }
        qrView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 194, height: 194))
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(27)
            $0.centerX.equalTo(titleLabel.snp.centerX)
        }
        qrSubtitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(titleLabel.snp.centerX)
            $0.top.equalTo(qrView.snp.bottom).offset(9)
            $0.height.equalTo(18)
        }
        codeLael.snp.makeConstraints {
            $0.centerX.equalTo(titleLabel.snp.centerX)
            $0.top.equalTo(qrSubtitleLabel.snp.bottom).offset(19)
            $0.size.equalTo(CGSize(width: 140, height: 30))
        }
        wechatBtn.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 63, height: 63))
            $0.top.equalTo(codeLael.snp.bottom).offset(13)
            $0.centerX.equalTo(titleLabel.snp.centerX)
        }
        wechatBtnLabel.snp.makeConstraints {
            $0.top.equalTo(wechatBtn.snp.bottom).offset(0)
            $0.centerX.equalTo(titleLabel.snp.centerX)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
