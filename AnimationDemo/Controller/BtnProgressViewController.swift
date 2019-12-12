//
//  BtnProgressViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/24.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class BtnProgressViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var imageVIew: UIImageView!
    var progressView: FXTutorialProgressView!
    @IBOutlet weak var animateView: UIView!
    var tag: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        animateView.backgroundColor = .white
        progressView = FXTutorialProgressView(frame: CGRect(x: 20, y: animateView.center.y - 50, width: view.bounds.width - 40, height: 46))
        animateView.addSubview(progressView)
        progressView.reloadBtnDidClick = {[weak self] in
            self?.slider.value = 0
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.progressView.gradientView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
    }
    
    @IBAction func sliderProgreeAction(_ sender: UISlider) {
        progressView.setProgress(CGFloat(sender.value), hasError: tag == 1)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        tag = sender.tag
    }
    
}


class FXTutorialProgressView: UIView {
    var reloadBtnDidClick: (() -> Void)?
    struct UISize {
        static let progressBorder: CGFloat = 23
        static let progressLinWidth: CGFloat = 10
        static let progressViewContainerSize: CGSize = CGSize(width: 46, height: 46)
    }
    fileprivate lazy var progressContentView: UIView = {
        let progressContentView = UIView()
        progressContentView.layer.masksToBounds = true
        progressContentView.layer.cornerRadius = 10
        return progressContentView
    }()
    fileprivate lazy var shadowView: UIView = {
        let progressContentView = UIView()
        progressContentView.backgroundColor = UIColor.red
        return progressContentView
    }()
    fileprivate lazy var titleLabel: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    lazy var backView: FXGradientView = {
        let maxTrackView = FXGradientView()
        maxTrackView.alpha = 1
        (maxTrackView.layer as! CAGradientLayer).colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        (maxTrackView.layer as! CAGradientLayer).startPoint = CGPoint(x: 0, y: 0.5)
        (maxTrackView.layer as! CAGradientLayer).endPoint = CGPoint(x: 1, y: 0.5)
        return maxTrackView
    }()
    fileprivate lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return whiteView
    }()
    
    lazy var gradientView: FXGradientView = {
        let maxTrackView = FXGradientView()
        (maxTrackView.layer as! CAGradientLayer).colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        maxTrackView.alpha = 1
        maxTrackView.layer.cornerRadius = 23
        maxTrackView.layer.masksToBounds = true
        (maxTrackView.layer as! CAGradientLayer).startPoint = CGPoint(x: 0, y: 0.5)
        (maxTrackView.layer as! CAGradientLayer).endPoint = CGPoint(x: 1, y: 0.5)
        return maxTrackView
    }()
    fileprivate var isProgress: Bool = false
    
    fileprivate lazy var startBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    fileprivate lazy var reloadBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("加载失败，点击刷新", for: .normal)
        return btn
    }()
    fileprivate lazy var reloadBgView: UIView = {
        let reloadBgView = UIView()
        reloadBgView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return reloadBgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        addSubview(shadowView)
        addSubview(progressContentView)
        progressContentView.addSubview(backView)
        progressContentView.addSubview(whiteView)
        progressContentView.addSubview(gradientView)
        progressContentView.addSubview(reloadBgView)
        
        progressContentView.addSubview(titleLabel)
        progressContentView.addSubview(startBtn)
        progressContentView.addSubview(reloadBtn)
        
        
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isProgress {
            progressContentView.frame = bounds
            gradientView.frame = CGRect(x: -UISize.progressBorder, y: 0, width: 0, height: bounds.height)
            backView.frame = bounds
            whiteView.frame = bounds
            titleLabel.frame = bounds
            reloadBtn.frame = CGRect(x: 0, y: -bounds.height, width: bounds.width, height: bounds.height)
            reloadBgView.frame = CGRect(x: 0, y: -bounds.height, width: bounds.width, height: bounds.height)
            startBtn.frame = CGRect(x: 0, y: -bounds.height, width: bounds.width, height: bounds.height)
            shadowView.frame = CGRect(x: 10, y: 10, width: bounds.width - 10 * 2, height: bounds.height - 10 * 2)
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 8)
            shadowView.layer.shadowRadius = 20
            shadowView.layer.shadowOpacity = 0.8
            shadowView.layer.shadowColor = UIColor(hex: 0xB196ED)?.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func createGrdientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: 0x7ad3ff)!.cgColor,
            UIColor(hex: 0xe261e0)!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }
    
    func setProgress(_ progress: CGFloat, hasError: Bool = false) {
        debugPrint("progress:\(progress)")
        isProgress = true
        gradientView.frame.size.width = progress * (bounds.width + UISize.progressBorder * 2)
        titleLabel.setTitle("加载中...", for: .normal)
        if progress >= 1 && !hasError {
            startBtn.setTitle("开始", for: .normal)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: -15, options: [.transitionCrossDissolve], animations: {
                self.startBtn.frame.origin.y = 0
                self.titleLabel.frame.origin.y = self.bounds.height
            }, completion: nil)
        } else if hasError {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: [],
                           animations: {
                            self.gradientView.frame.size.width = self.bounds.width + UISize.progressBorder * 2
            }, completion: nil)
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                self.reloadBtn.frame.origin.y = 0
                self.reloadBgView.frame.origin.y = -10
                self.reloadBgView.frame.size.height = self.bounds.height + 10
                self.titleLabel.frame.origin.y = self.bounds.height
            }, completion: { _ in
                self.reloadBtn.removeTarget(self, action: #selector(self.reloadBtnAction), for: .touchUpInside)
                self.reloadBtn.addTarget(self, action: #selector(self.reloadBtnAction), for: .touchUpInside)
            })
        }
    }
    
    @objc fileprivate func reloadBtnAction() {
        titleLabel.setTitle("加载失败，点击刷新", for: .normal)
        reloadBtnDidClick?()
        gradientView.frame.size.width = 0
        startBtn.frame.origin.y = -bounds.height
        reloadBtn.frame.origin.y = -bounds.height
        self.reloadBgView.frame.origin.y = -(self.bounds.height + 10)
        self.reloadBgView.frame.size.height = self.bounds.height + 10
        titleLabel.isHidden = false
        titleLabel.frame.origin.y = 0
    }
    
    @objc fileprivate func startnAction() {
        reloadBtnDidClick?()
    }
    
}


