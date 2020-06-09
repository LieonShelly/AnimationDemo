//
//  FXTutorialToast.swift
//  PgImageProEditUISDK
//
//  Created by lieon on 2020/3/11.
//

import Foundation
import UIKit

class FXTutorialToast: UIView {
    struct UISize {
        static let labelHeight: CGFloat = 14
        static let labelMinMargin: CGFloat = 20
        static let labelPadding: CGFloat = 30
        static let labelTop: CGFloat = 13.5
        static let labelbottom: CGFloat = 13.5
    }
    fileprivate lazy var bgLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.customFont(ofSize: 14.0.fitiPhone5sSerires)
        label.backgroundColor = UIColor(hex: 0x1c1c1c)?.withAlphaComponent(0.7)
        label.layer.cornerRadius = 8.fitiPhone5sSerires
        label.layer.masksToBounds = true
        label.layer.opacity = 0
        return label
    }()
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.customFont(ofSize: 14.0.fitiPhone5sSerires)
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.layer.cornerRadius = 8.fitiPhone5sSerires
        label.layer.masksToBounds = true
        label.layer.opacity = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgLabel)
        addSubview(label)
        label.snp.makeConstraints {
            $0.bottom.equalTo(-168 - 12)
            $0.height.greaterThanOrEqualTo(UISize.labelHeight)
            $0.centerX.equalTo(snp.centerX)
        }
        bgLabel.snp.makeConstraints {
            $0.bottom.equalTo(label.snp.bottom).offset(UISize.labelbottom)
            $0.top.equalTo(label.snp.top).offset(-UISize.labelTop)
            $0.left.equalTo(label.snp.left).offset(-UISize.labelPadding)
            $0.right.equalTo(label.snp.right).offset(UISize.labelPadding)
            $0.left.greaterThanOrEqualTo(UISize.labelMinMargin)
            $0.right.lessThanOrEqualTo(-UISize.labelMinMargin)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FXTutorialToast {
    
    func updateInset(_ bottomInset: CGFloat, animate: Bool) {
        label.sizeToFit()
        label.snp.updateConstraints {
            $0.bottom.equalTo(-bottomInset)
        }
        if animate {
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
    
    func show(_ text: String, bottomInset: CGFloat) {
        if text.isEmpty {
            return
        }
        label.text = text
        label.sizeToFit()
        label.snp.updateConstraints {
            $0.bottom.equalTo(-bottomInset)
        }
        layoutIfNeeded()
        if label.layer.opacity == 1 {
            return
        }
        showAnimaiton()
    }
    
    func forceDismiss() {
        dismiss()
    }
}

extension FXTutorialToast {

    fileprivate func dismiss() {
        if bgLabel.layer.opacity == 0 {
            return
        }
        if label.layer.opacity == 0 {
            return
        }
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0
        opacity.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        opacity.isRemovedOnCompletion = false
        opacity.duration = 0.25
        opacity.delegate = self
        opacity.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "easeInEaseOut"))
        opacity.setValue("dismiss", forKey: "name")
        bgLabel.layer.add(opacity, forKey: nil)
        label.layer.add(opacity, forKey: nil)
    
    }
    
    fileprivate func showAnimaiton() {
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1
        opacity.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        opacity.isRemovedOnCompletion = false
        opacity.duration = 0.25
        opacity.delegate = self
        opacity.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "easeInEaseOut"))
        opacity.setValue("showAnimaiton", forKey: "name")
        label.layer.add(opacity, forKey: nil)
        bgLabel.layer.add(opacity, forKey: nil)
    }
}

extension FXTutorialToast: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let name = anim.value(forKey: "name") as? String, name == "dismiss" {
            bgLabel.layer.opacity = 0
            label.text = nil
            label.layer.opacity = 0
            label.layer.removeAllAnimations()
            bgLabel.layer.removeAllAnimations()
        } else  if let name = anim.value(forKey: "name") as? String, name == "showAnimaiton" {
            bgLabel.layer.opacity = 1
            label.layer.opacity = 1
        }
    }
}
