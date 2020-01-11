//
//  NewAnimatedViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/1/11.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class NewAnimatedViewController: UIViewController {
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var naviBar: UIView!
    fileprivate var naviBarOriginFrame: CGRect = .zero
    fileprivate var isShow: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.layer.cornerRadius = 10
        naviBar.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 10
        nextBtn.layer.masksToBounds = true
        naviBar.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        naviBarOriginFrame = naviBar.frame
    }
 
    @IBAction func btnClick(_ sender: Any) {
        if isShow {
            dismissAnimation()
        } else {
            showAnimation()
        }
    }
    
    fileprivate func dismissAnimation() {
        UIView.animateKeyframes(withDuration: 0.5,
                                delay: 0,
                                options: [.calculationModeLinear],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25) {
                                                        self.naviBar.frame = CGRect(origin: self.naviBarOriginFrame.origin,
                                                                                    size: CGSize(width: self.naviBarOriginFrame.width + 50,
                                                                                                 height: self.naviBarOriginFrame.height + 50))
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                       relativeDuration: 0.25) {
                                                        self.naviBar.frame = CGRect(origin: self.naviBarOriginFrame.origin, size: .zero)
                                    }
        }, completion: nil)
        
        UIView.animateKeyframes(withDuration: 0.25,
                                delay: 0.0,
                                options: [.calculationModeLinear],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.125) {
                                                        self.nextBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.125,
                                                       relativeDuration: 0.125) {
                                                        self.nextBtn.transform = CGAffineTransform(scaleX: 0, y: 0)
                                    }
        }, completion: { _ in
            self.isShow = false
        })
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.naviBar.alpha = 0
        }, completion: nil)
    }
    
    fileprivate func showAnimation() {
        naviBar.frame = CGRect(origin: naviBarOriginFrame.origin, size: .zero)
        naviBar.alpha = 1
        UIView.animate(withDuration: 0.5,
                       delay: 0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.naviBar.frame = self.naviBarOriginFrame
        }, completion: nil)
        
        
        nextBtn.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.25,
                       delay: 0.25,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.nextBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            self.isShow = true
        })
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.naviBar.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.35,
                       delay: 0.25,
                       options: [.curveEaseInOut],
                       animations: {
                        self.nextBtn.alpha = 1
        }, completion: nil)
    }
}
