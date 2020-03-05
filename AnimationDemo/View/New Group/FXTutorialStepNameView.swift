//
//  FXTutorialStepNameView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/4.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class FXTutorialStepNameView: UIView {
    var existBtnClick: (() -> ())?
    var titleBtnClick: ((CGFloat, Bool) -> ())?
    class FXDownArrowView: UIView {
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            let startPoint = CGPoint(x: 0, y: 0)
            let middlePoint = CGPoint(x: rect.width * 0.5, y: rect.height)
            let endPoint = CGPoint(x: rect.width, y: 0)
            let path = UIBezierPath()
            path.move(to: startPoint)
            path.addLine(to: middlePoint)
            path.addLine(to: endPoint)
            path.lineWidth = 1
            UIColor.white.setStroke()

            path.lineJoinStyle = .bevel
            path.stroke()
            backgroundColor = UIColor.clear
        }
    }
    enum ViewState {
        case normal
        /// 展开状态
        case expand
    }
    var viewState: ViewState = .normal
    fileprivate lazy var titleBtn: UIButton = {
        let arrowBtn = UIButton(type: UIButton.ButtonType.system)
        arrowBtn.setTitle("百变背景", for: .normal)
        arrowBtn.titleLabel?.font = UIFont.customFont(ofSize: 14)
        arrowBtn.setTitleColor(UIColor.white, for: .normal)
        return arrowBtn
    }()
    lazy var arrow: FXDownArrowView = {
        let arrow = FXDownArrowView()
        arrow.alpha = 0
        return arrow
    }()
    lazy var existBtn: UIButton = {
        let arrowBtn = UIButton(type: UIButton.ButtonType.system)
        arrowBtn.titleLabel?.font = UIFont.customFont(ofSize: 14)
        arrowBtn.setTitleColor(UIColor.white, for: .normal)
        arrowBtn.alpha = 0
        return arrowBtn
    }()
    fileprivate lazy var blurBg: VisualEffectView = {
        let blurBg = VisualEffectView()
        blurBg.blurRadius = 16
        return blurBg
    }()
    var existBtnTitle: NSMutableAttributedString {
        let title = "退出".localized_FX()
        let attri = NSMutableAttributedString(string: "退出".localized_FX())
        attri.addAttributes([NSAttributedString.Key.font : UIFont.customFont(ofSize: 14),
                             NSAttributedString.Key.foregroundColor : UIColor.white,
            ],
                            range: NSRange(location: 0, length: title.count))
        return attri
    }
    struct UISize {
        static let arrowSize: CGSize = CGSize(width: 8, height: 4)
        static let arrowLeft: CGFloat = 8
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleBtn.addTarget(self, action: #selector(titleBtnAction), for: .touchUpInside)
        existBtn.setAttributedTitle(existBtnTitle, for: .normal)
        backgroundColor =  UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 37 / 255.0, alpha: 0.16)
        addSubview(blurBg)
        addSubview(existBtn)
        addSubview(arrow)
        addSubview(titleBtn)
        let line = createSeperateLine()
        addSubview(line)
        arrow.transform = CGAffineTransform(rotationAngle: .pi * 2)
        blurBg.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        let titleWidth: CGFloat =  56
        let titleHeight: CGFloat = 20
        titleBtn.snp.makeConstraints {
            $0.left.equalTo(24)
            $0.top.equalTo(12)
            $0.width.equalTo(titleWidth)
            $0.height.equalTo(titleHeight)
        }
        arrow.snp.makeConstraints {
            $0.left.equalTo(titleBtn.snp.right).offset(UISize.arrowLeft)
            $0.size.equalTo(UISize.arrowSize)
            $0.centerY.equalTo(titleBtn.snp.centerY)
        }
        line.snp.makeConstraints {
            $0.left.equalTo(13)
            $0.right.equalTo(-13)
            $0.height.equalTo(1)
            $0.top.equalTo(titleBtn.snp.bottom).offset(11.8)
        }
        existBtn.snp.makeConstraints {
            $0.left.equalTo(titleBtn.snp.left)
            $0.width.greaterThanOrEqualTo(28)
            $0.height.equalTo(20)
            $0.top.equalTo(line.snp.bottom).offset(16.5)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension FXTutorialStepNameView {
    func config(_ title: String,  isShowArrow: Bool = false, compeletion: ((CGFloat) -> ())?) {
        let attri = NSMutableAttributedString(string: title)
        attri.addAttributes([NSAttributedString.Key.font : UIFont.customFont(ofSize: 14),
                             NSAttributedString.Key.foregroundColor : UIColor.white,
            ],
                            range: NSRange(location: 0, length: title.count))
        let textWidth = attri.boundingRect(with: CGSize(width: CGFloat.infinity, height: 20), options: [.usesLineFragmentOrigin], context: nil).size.width
        let minTextWidth = existBtnTitle.boundingRect(with: CGSize(width: CGFloat.infinity, height: 20), options: [.usesLineFragmentOrigin], context: nil).size.width
        let margin: CGFloat = 24
        let minWidth = margin * 2 + minTextWidth
        let titleWidth = (margin * 2 + textWidth) < minWidth ? minWidth : (margin * 2 + textWidth)
        titleBtn.setAttributedTitle(attri, for: .normal)
        titleBtn.snp.updateConstraints {
            $0.width.equalTo(textWidth)
        }
        /// 回调给外部是否需要更新自身宽度
        if isShowArrow {
             arrow.alpha = isShowArrow ? 1 : 0
            compeletion?(titleWidth + UISize.arrowLeft + UISize.arrowSize.width)
        } else {
            compeletion?(titleWidth)
        }
    }
}

extension FXTutorialStepNameView {
    fileprivate func createSeperateLine() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.11)
        return view
    }
    
    @objc
    fileprivate func titleBtnAction() {
        switch viewState {
        case .normal: /// 如果当前状态是正常状态，则变为展开状态
            self.viewState = .expand
            titleBtnClick?(44 + 1 + 53.4, true)
        case .expand:
            self.viewState = .normal
            titleBtnClick?(44.0, false)
        }
    }
}
