//
//  FXVerticalColorSlider.swift
//  AnimationDemo
//
//  Created by lieon on 2020/9/9.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit

class FXVerticalColorSlider: UIView {
    fileprivate lazy var colors: [UIColor] = ["#ffffff", "#ffc4c4", "#ffd8b1", "#ffebb1", "#f6ffb1", "#d2ffd2", "#d2fffb", "#b8f4ff", "#cbd3ff", "#ebccff", "#ffdcff"].map { $0.getColor()!}
    fileprivate(set) var currentColor: UIColor?
    fileprivate lazy var gradientView: FXGradientView = {
        let view = FXGradientView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    fileprivate lazy var gradientShadow: FXShadowView = {
        let thumbView = FXShadowView()
        thumbView.layer.cornerRadius = 5
        thumbView.backgroundColor = .white
        thumbView.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        thumbView.shadowRadius = 5
        thumbView.shadowOffset = .zero
        return thumbView
    }()
    fileprivate lazy var thumbView: FXShadowView = {
        let thumbView = FXShadowView()
        thumbView.layer.cornerRadius = 4
        thumbView.backgroundColor = .white
        thumbView.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        thumbView.shadowRadius = 5
        thumbView.shadowOffset = .zero
        return thumbView
    }()
    fileprivate(set) var progress: CGFloat = 0
    
    struct UISize {
        static let thumbSize: CGSize = CGSize(width: 27, height: 17)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(gradientShadow)
        addSubview(gradientView)
        addSubview(thumbView)
        let gradientLayer = (gradientView.layer as?  CAGradientLayer)
        gradientLayer?.colors = colors.map { $0.cgColor }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbView.frame = CGRect(x: (bounds.width - UISize.thumbSize.width) * 0.5,
                                 y: 0,
                                 width: UISize.thumbSize.width,
                                 height: UISize.thumbSize.height)
        thumbView.center.y = bounds.height * progress
        let gradientW: CGFloat = 10
        gradientView.frame = CGRect(x: (bounds.width - gradientW) * 0.5 , y: 0, width: gradientW, height: bounds.height)
        gradientShadow.frame = CGRect(x: (bounds.width - gradientW) * 0.5 , y: 0, width: gradientW, height: bounds.height)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func config(_ progress: CGFloat) {
        self.progress = progress
        var startColorIndex = floor((CGFloat(colors.count - 1) * progress))
        var endIndex = startColorIndex + 1
        if endIndex > CGFloat(colors.count - 1){
            endIndex = CGFloat(colors.count - 1)
        }
        let realProgress = CGFloat(colors.count) * progress
        let detlaProgress = realProgress - startColorIndex
        
        if startColorIndex < 0 {
            startColorIndex = 0
        } else if startColorIndex > CGFloat(colors.count - 1) {
            startColorIndex = CGFloat(colors.count - 1)
        }
        let startColor = colors[Int(startColorIndex)]
        let endColor = colors[Int(endIndex)]
        let endColorR = startColor.getColorRGB().red + (endColor.getColorRGB().red - startColor.getColorRGB().red) * detlaProgress
        let endColorG = startColor.getColorRGB().green + (endColor.getColorRGB().green - startColor.getColorRGB().green) * detlaProgress
        let endColorB = startColor.getColorRGB().blue + (endColor.getColorRGB().blue - startColor.getColorRGB().blue) * detlaProgress
        setNeedsLayout()
        currentColor = UIColor(red: endColorR, green: endColorG, blue: endColorB, alpha: 1)
    }
    
    func configColors(_ colors: [UIColor], colorSelectIndex: Int = 0) {
        self.colors.removeAll()
        self.colors.append(contentsOf: colors)
        (gradientView.layer as? CAGradientLayer)?.colors = colors.map { $0.cgColor }
        let progress = CGFloat(colorSelectIndex) / CGFloat (colors.count - 1)
        config(progress)
    }
    
    func configColors(_ colors: [UIColor], progress: CGFloat = 0) {
        self.colors.removeAll()
        self.colors.append(contentsOf: colors)
        (gradientView.layer as? CAGradientLayer)?.colors = colors.map { $0.cgColor }
        config(progress)
    }
    
    func configColorLocations(_ locations: [CGFloat]) {
        let gradientLayer = (gradientView.layer as?  CAGradientLayer)
        gradientLayer?.locations = locations.map { NSNumber(floatLiteral: Double($0))}
    }
}

class FXVerticalColorSliderView: UIView {
    lazy var iconView: UIButton = {
        let iconView = UIButton(type: .custom)
//        let image = FXEditDataManager.getImage("ic_color_slidet_dot@3x", isOther: true)
//        iconView.setImage(image, for: .normal)
        return iconView
    }()
    var progress: CGFloat {
        return slider.progress
    }
    fileprivate lazy var slider: FXVerticalColorSlider = {
        let slider = FXVerticalColorSlider()
        return slider
    }()
    var currentProgressColor: UIColor? {
        return slider.currentColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconView)
        addSubview(slider)
        iconView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 41, height: 41))
        }
        slider.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.bottom).offset(27)
            $0.width.equalTo(27)
            $0.centerX.equalTo(iconView.snp.centerX)
            $0.height.equalTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func config(_ progress: CGFloat) {
        var progress = progress
        if progress > 1 {
            progress = 1
        } else if progress < 0 {
            progress = 0
        }
        slider.config(progress)
    }
    
    func configColors(_ colors: [UIColor], colorSelectIndex: Int = 0)  {
        slider.configColors(colors, colorSelectIndex: colorSelectIndex)
    }
    
    func configColors(_ colors: [UIColor], progress: CGFloat = 0) {
        slider.configColors(colors, progress: progress)
    }
    
    func configColorLocations(_ locations: [CGFloat]) {
        slider.configColorLocations(locations)
    }
}

protocol FXVerticalColorSliderAnimateViewDeleate: NSObjectProtocol {
    func sliderAnimateViewValueChanged(_ progress: CGFloat, currentColor: UIColor?)
    func sliderAnimateViewMoveEnd(_ progress: CGFloat, currentColor: UIColor?)
    func sliderAnimateViewBtnDidTap()
}

class FXVerticalColorSliderAnimateView: UIView {
    var sliderValueChanged: ((_ progress: CGFloat, _ color: UIColor?) -> Void)?
    var sliderMoveEnd: ((_ progress: CGFloat, _ color: UIColor?) -> Void)?
    var btnDidTap: (() -> Void)?
    weak var delegate: FXVerticalColorSliderAnimateViewDeleate?
    fileprivate lazy var sliderView: FXVerticalColorSliderView = {
        let sliderView = FXVerticalColorSliderView()
        return sliderView
    }()
    fileprivate lazy var colors: [UIColor] = []
    fileprivate var topColor: UIColor?
    struct UISize {
        static let leftInset: CGFloat = 2
        static let silderViewW: CGFloat = 27
    }
    fileprivate var lastRatio: CGFloat = 0
    fileprivate var currentRatio: CGFloat = 0
    fileprivate var startRatio: CGFloat = 0
    fileprivate var isHandle: Bool = false
    var currentColor: UIColor? {
        return sliderView.currentProgressColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sliderView)
        sliderView.snp.makeConstraints {
            $0.left.equalTo(UISize.leftInset)
            $0.top.bottom.equalTo(0)
            $0.width.equalTo(UISize.silderViewW)
        }
        let ges = UIPanGestureRecognizer(target: self, action: #selector(moveGestAction(_:)))
        addGestureRecognizer(ges)
        sliderView.iconView.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 设置颜色以及选中的颜色
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - colorSelect: 选中的颜色必须是colors颜色数组中的颜色，这样才找得到
    func configColors(_ colors: [UIColor], colorSelect: UIColor) {
        guard !colors.isEmpty else { return }
        self.colors.removeAll()
        self.colors.append(contentsOf: colors)
        let inputColorValue = colorSelect.getColorRGB()
        if let index =  colors.map({ $0.getColorRGB() }).firstIndex(where: { (red, green, blue) -> Bool in
            return inputColorValue.red == red && inputColorValue.green == green && inputColorValue.blue == blue
        }) {
            sliderView.configColors(colors, colorSelectIndex: index)
            lastRatio = sliderView.progress
        } else {
            sliderView.configColors(colors, colorSelectIndex: 0)
            lastRatio = sliderView.progress
        }
        topColor = colors.first
    }
    
    /// 设置颜色以及选中的进度
    func configColors(_ colors: [UIColor], progress: CGFloat) {
        guard !colors.isEmpty else { return }
        var progress = progress
        if progress > 1 {
            progress = 1
        } else if progress < 0 {
            progress = 0
        }
        self.colors.removeAll()
        self.colors.append(contentsOf: colors)
        sliderView.configColors(colors, progress: CGFloat(progress))
        lastRatio = sliderView.progress
        topColor = colors.first
    }
    
    /// 设置进度
    func configProgress(_ progress: CGFloat) {
        guard !colors.isEmpty else { return }
        var progress = progress
        if progress > 1 {
            progress = 1
        } else if progress < 0 {
            progress = 0
        }
        sliderView.configColors(colors, progress: CGFloat(progress))
        lastRatio = sliderView.progress
        topColor = colors.first
    }
    
    /// 设置选中颜色
    func configColorSelect(_ selectColor: UIColor) {
        guard !colors.isEmpty else { return }
        let inputColorValue = selectColor.getColorRGB()
        if let index = colors.map({ $0.getColorRGB() }).firstIndex(where: { (red, green, blue) -> Bool in
            return inputColorValue.red == red && inputColorValue.green == green && inputColorValue.blue == blue
        }) {
            sliderView.configColors(colors, colorSelectIndex: index)
            lastRatio = sliderView.progress
        } else {
            sliderView.configColors(colors, colorSelectIndex: 0)
            lastRatio = sliderView.progress
        }
    }
    
    func showOrHiddenSlider(_ isShow: Bool) {
        if isShow {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.sliderView.frame.origin.x = UISize.leftInset
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.sliderView.frame.origin.x = self.bounds.width - UISize.silderViewW * 0.5
            }, completion: nil)
        }
    }
}

extension FXVerticalColorSliderAnimateView {
    
    @objc
    fileprivate func moveGestAction(_ ges: UIPanGestureRecognizer) {
        let locationY = ges.location(in: self).y
        switch ges.state {
        case .began:
            isHandle = true
            showOrHiddenSlider(true)
            startRatio = locationY / bounds.height
        case .changed:
            isHandle = true
            let currentChanedRatio = locationY / bounds.height
            currentRatio = lastRatio + (currentChanedRatio - startRatio)
            if currentRatio > 1 {
                currentRatio = 1
            } else if currentRatio < 0 {
                currentRatio = 0
            }
            sliderView.config(currentRatio)
            sliderValueChanged?(currentRatio, sliderView.currentProgressColor)
            delegate?.sliderAnimateViewValueChanged(currentRatio, currentColor: sliderView.currentProgressColor)
        case .ended, .cancelled:
            isHandle = false
            lastRatio = currentRatio
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.isHandle {
                    return
                }
                self.showOrHiddenSlider(false)
            }
            if currentRatio > 1 {
                currentRatio = 1
            } else if currentRatio < 0 {
                currentRatio = 0
            }
            sliderMoveEnd?(currentRatio, sliderView.currentProgressColor)
            delegate?.sliderAnimateViewMoveEnd(currentRatio, currentColor: sliderView.currentProgressColor)
        default:
            if currentRatio > 1 {
                currentRatio = 1
            } else if currentRatio < 0 {
                currentRatio = 0
            }
            sliderView.config(currentRatio)
        }
    }
    
    @objc
    fileprivate func tapAction() {
        btnDidTap?()
        delegate?.sliderAnimateViewBtnDidTap()
    }
    
    
}


