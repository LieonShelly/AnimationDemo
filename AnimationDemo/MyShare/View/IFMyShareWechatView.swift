//
//  IFMyShareWechatView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/12/25.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class IFMyShareWechatView: UIView {
    fileprivate lazy var topBg: UIImageView = {
        let topBg = UIImageView()
        topBg.image = UIImage(named: "ic_share_wh_bg")
        return topBg
    }()
    fileprivate lazy var nameLogo: UIImageView = {
        let nameLogo = UIImageView()
        nameLogo.image = UIImage(named: "ic_share_wh_bg_name")
        return nameLogo
    }()
    lazy var nameDescLabel: UILabel = {
        let label = UILabel()
        let attr0 = NSMutableAttributedString(string: "商业级人像精修神器")
        attr0.addAttributes([.font: UIFont(name: "PingFangSC-Light", size: 11)!,
                             .foregroundColor: UIColor(hex: 0x838383)!,
                             .kern: 1.5],
                            range: NSRange(location: 0, length: attr0.string.count))
        label.attributedText = attr0
        return label
    }()
    fileprivate lazy var bottomLogo: UIImageView = {
        let bottomLogo = UIImageView()
        bottomLogo.image = UIImage(named: "ic_my_share_wh_inface")
        return bottomLogo
    }()
    lazy var qrView: UIImageView = {
        let bottomLogo = UIImageView()
        bottomLogo.image = UIImage(named: "qr-1")
        return bottomLogo
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangSC-Semibold", size: 22)
        label.textColor = UIColor(hex: 0x333333)
        label.text = "圣诞节晚上约拍"
        return label
    }()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "PingFangSC-Regular", size: 15)
        label.textColor = UIColor(hex: 0x9e9e9e)
        label.textAlignment = .center
        label.text = "2020-12-08"
        return label
    }()
    fileprivate lazy var qrSubtitleLabel: UILabel = {
        let label = UILabel()
        let attr0 = NSMutableAttributedString(string: "扫码查看高清大图")
        attr0.addAttributes([.font: UIFont(name: "PingFangSC-Regular", size: 14)!,
                             .foregroundColor: UIColor(hex: 0x333333)!,
                             .kern: 2],
                            range: NSRange(location: 0, length: attr0.string.count))
        label.attributedText = attr0
        return label
    }()
    fileprivate lazy var bottomtitleLabelbg: UIImageView = {
        let bottomLogo = UIImageView()
        bottomLogo.image = UIImage(named: "ic_share_wh_title_bg")
        return bottomLogo
    }()
    fileprivate lazy var bottomtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Semibold", size: 12)
        label.textColor = UIColor(hex: 0xa38065)
        label.text = "支持高质量下载"
        return label
    }()
    fileprivate lazy var qrBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var qrContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xf9f9f9)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0xeeeeee)
        addSubview(topBg)
        addSubview(nameLogo)
        addSubview(nameDescLabel)
        addSubview(bottomLogo)
        addSubview(qrContainer)
        qrContainer.addSubview(titleLabel)
        qrContainer.addSubview(subtitleLabel)
        qrContainer.addSubview(qrBgView)
        qrBgView.addSubview(qrView)
        qrContainer.addSubview(qrSubtitleLabel)
        qrContainer.addSubview(bottomtitleLabelbg)
        qrContainer.addSubview(bottomtitleLabel)
        topBg.snp.makeConstraints {
            $0.left.right.top.equalTo(0)
            $0.height.equalTo(487)
        }
        nameLogo.snp.makeConstraints {
            $0.top.equalTo(UIDevice.current.isiPhoneXSeries ? 188 - 10 : 107 - 10)
            $0.left.equalTo(37)
            $0.size.equalTo(CGSize(width: 110, height: 27))
        }
        nameDescLabel.snp.makeConstraints {
            $0.left.equalTo(nameLogo.snp.left)
            $0.top.equalTo(nameLogo.snp.bottom).offset(7)
            $0.height.equalTo(16)
        }
        qrContainer.snp.makeConstraints {
            $0.left.equalTo(28)
            $0.right.equalTo(-28)
            $0.height.equalTo(437)
            $0.top.equalTo(nameDescLabel.snp.bottom).offset(25 + 10)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(44)
            $0.height.equalTo(30)
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
            $0.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.height.equalTo(21)
            $0.centerX.equalTo(titleLabel.snp.centerX)
        }
        qrBgView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 179, height: 179))
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(33 - 11)
            $0.centerX.equalTo(titleLabel.snp.centerX)
        }
        qrView.snp.makeConstraints {
            $0.left.top.equalTo(4.5)
            $0.right.bottom.equalTo(-4.5)
        }
        qrSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(qrBgView.snp.bottom).offset(19)
            $0.height.equalTo(20)
            $0.centerX.equalTo(qrContainer.snp.centerX)
        }
        bottomtitleLabelbg.snp.makeConstraints {
            $0.right.bottom.equalTo(0)
        }
        bottomtitleLabel.snp.makeConstraints {
            $0.left.equalTo(bottomtitleLabelbg.snp.left).offset(23)
            $0.right.equalTo(bottomtitleLabelbg.snp.right).offset(-11)
            $0.top.equalTo(bottomtitleLabelbg.snp.top).offset(8)
            $0.bottom.equalTo(bottomtitleLabelbg.snp.bottom).offset(-8)
        }
        bottomLogo.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.bottom.equalTo(0)
            $0.height.equalTo(123)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func snapShotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        return img
    }
}
