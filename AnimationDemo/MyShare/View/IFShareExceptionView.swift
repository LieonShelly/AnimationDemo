//
//  IFExceptionView.swift
//  InFace
//
//  Created by lieon on 2020/12/24.
//  Copyright © 2020 Pinguo. All rights reserved.
//

import UIKit

class IFExceptionView: UIView {
    struct UIEntity {
        var icon: UIImage
        var title: String
    }
    enum ExceptionType {
        case none
        case empty(UIEntity)
        case reload(UIEntity)
    }
    fileprivate lazy var icon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 14)
        titleLabel.textColor = UIColor(hex: 0x999999)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var btn: IFButton = {
        let btn = IFButton(style: .common)
        btn.setTitle("点击重试".localized(nil), for: .normal)
        return btn
    }()
    fileprivate lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(titleLabel)
        addSubview(stack)
        addSubview(btn)
        setupTheme()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ type: ExceptionType) {
        switch type {
        case .none:
            self.isHidden = true
        case .empty(let uiEnty):
            self.isHidden = false
            icon.image = uiEnty.icon
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 7
            style.alignment = .center
            let attri = NSMutableAttributedString(string: uiEnty.title)
            attri.addAttributes([.font : UIFont(name: "PingFangSC-Medium", size: 14)!,
                                 .foregroundColor: UIColor(hex: 0x999999)!,
                                 .paragraphStyle: style],
                                range: NSRange(location: 0, length: attri.string.count))
            titleLabel.attributedText = attri
            stack.spacing = 8
            stack.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.left.equalTo(55)
                $0.right.equalTo(-55)
                $0.centerY.equalTo(snp.centerY).offset(UIDevice.current.isiPhoneXSeries ? -60 - 11 : -30 - 11)
            }
            btn.isHidden = true
        case .reload(let uiEnty):
            self.isHidden = false
            icon.image = uiEnty.icon
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 7
            style.alignment = .center
            let attri = NSMutableAttributedString(string: uiEnty.title)
            attri.addAttributes([.font : UIFont(name: "PingFangSC-Medium", size: 14)!,
                                 .foregroundColor: UIColor(hex: 0x999999)!,
                                 .paragraphStyle: style],
                                range: NSRange(location: 0, length: attri.string.count))
            titleLabel.attributedText = attri
            stack.spacing = 10 - 3 / 2
            stack.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.left.equalTo(55)
                $0.right.equalTo(-55)
                $0.centerY.equalToSuperview().offset(UIDevice.current.isiPhoneXSeries ? -60 + 1.5 : -30 + 1.5)
            }
            btn.isHidden = false
            btn.snp.remakeConstraints {
                $0.centerX.equalTo(stack.snp.centerX)
                $0.size.equalTo(CGSize(width: 190, height: 52))
                $0.top.equalTo(stack.snp.bottom).offset(UIDevice.current.isiPhoneXSeries ? 158: 118)
            }
        }
    }
}

extension IFExceptionView {
    func setupTheme() {
//        registerTheme()
//        if IFThemeManager.currentUIStyle() == .dark {
//            backgroundColor = "#131313".getColor()
//        } else {
//            backgroundColor = "#f9f9f9".getColor()
//        }
    }
}
