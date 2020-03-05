//
//  FXTutorialStepView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/3/4.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation
import UIKit

class FXTutorialStepView: UIView {
    var exitClickAction: (() -> ())? {
        didSet {
            stepNumberView.clickAction = exitClickAction
        }
    }
    fileprivate lazy var stepNumberView: FXTutorialStepNumView = {
        let view = FXTutorialStepNumView()
        view.backgroundColor = .clear //  UIColor(red: 37 / 255.0, green: 37 / 255.0, blue: 37 / 255.0, alpha: 0.16)
//        view.layer.cornerRadius = UISize.stepNumViewSize.width * 0.5
//        view.layer.masksToBounds = true
        view.alpha = 0
        return view
    }()
    
    fileprivate lazy var nextStepView: FXTutorialNextStepView = {
        let view = FXTutorialNextStepView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate var isNeedLayout: Bool = true
    
    struct UISize {
        static let outterWidth: CGFloat = 3.2
        static let nextStepViewSize: CGSize = CGSize(width: 44.fitiPhone5sSerires, height: 44.fitiPhone5sSerires)
        static let stepNumViewSize: CGSize = CGSize(width: 44.fitiPhone5sSerires + outterWidth * 2, height: 44.fitiPhone5sSerires + outterWidth * 2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stepNumberView)
        addSubview(nextStepView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isNeedLayout {
            nextStepView.frame = CGRect(x: 0,
                                        y: (bounds.height + UISize.outterWidth * 2
                                            - UISize.stepNumViewSize.height) * 0.5,
                                        width: bounds.width - UISize.outterWidth,
                                        height: UISize.nextStepViewSize.height)
            
            stepNumberView.frame = CGRect(x: bounds.width - UISize.stepNumViewSize.width,
                                          y: (bounds.height - UISize.stepNumViewSize.height) * 0.5,
                                          width: UISize.stepNumViewSize.width,
                                          height: UISize.stepNumViewSize.height)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FXTutorialStepView {
    func update(_ progress: CGFloat) {
        stepNumberView.update(progress, compeletion: {[weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.nextStepView.showAnimation()
            weakSelf.nextStepView.scaleAnimationEnd = {
                weakSelf.stepNumberView.progressLayer.lineWidth = 0
            }
        })
    }
    
    func startShow(_ compeletion: (() -> ())?) {
        stepNumberView.alpha = 1
        nextStepView.isUserInteractionEnabled = false
        self.stepNumberView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       options: [.transitionCrossDissolve],
                       animations: {
                        self.stepNumberView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            compeletion?()
        })
    }
}
