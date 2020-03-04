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
    fileprivate lazy var stepNumberView: FXTutorialStepNumView = {
        let view = FXTutorialStepNumView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = UISize.cycleSize.width * 0.5
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var nextStepView: FXTutorialNextStepView = {
        let view = FXTutorialNextStepView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate var isNeedLayout: Bool = true
    
    struct UISize {
        static let cycleSize: CGSize = CGSize(width: 50, height: 50)
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
                                        y: (bounds.height - UISize.cycleSize.height) * 0.5,
                                        width: bounds.width, height: UISize.cycleSize.height)
            
            stepNumberView.frame = CGRect(x: bounds.width - UISize.cycleSize.width,
                                          y: (bounds.height - UISize.cycleSize.height) * 0.5,
                                          width: UISize.cycleSize.width, height: UISize.cycleSize.height)
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
}
