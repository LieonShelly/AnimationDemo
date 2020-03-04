//
//  FXScaleView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/4.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit

class FXScaleView: UIView {
    fileprivate lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = .gray
        coverView.alpha = 0
        return coverView
    }()
    
    var coverAnimationEnd: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverView.layer.cornerRadius = 50 * 0.5
        coverView.layer.masksToBounds = true
        coverView.frame = bounds
    }
    
    func showCoverAnimation() {
        coverView.alpha = 1
        coverView.layer.position.x = bounds.width - 50 -  50 * 0.5
        let position = CABasicAnimation(keyPath: "position.x")
        position.fromValue = bounds.width - 50 -  50 * 0.5
        position.toValue = bounds.width - 50 * 0.5
        position.fillMode = .forwards
        position.isRemovedOnCompletion = false
        position.duration = 0.25
        position.delegate = self
        position.setValue("showCoverAnimation", forKey: "name")
        position.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        coverView.layer.add(position, forKey: nil)
        coverView.layer.position.x = bounds.width - 50 * 0.5
    }
}

extension FXScaleView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag == true else {
            return
        }
        if let name = anim.value(forKey: "name") as? String, name == "showCoverAnimation" {
            coverAnimationEnd?()
            coverView.alpha = 0
        }
    }
}
