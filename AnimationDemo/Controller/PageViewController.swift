//
//  PageViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2020/6/25.
//  Copyright © 2020 lieon. All rights reserved.
//

import FSPagerView
import MXParallaxHeader

class PageViewController: UIViewController, MXParallaxHeaderDelegate {
    struct UISize {
        static let headerH: CGFloat = 400
        static let cellHeight: CGFloat = 600
    }
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    fileprivate lazy var headerView: IFRecommendHeader = {
        let view = IFRecommendHeader()
        view.backgroundColor = .red
        return view
    }()
    fileprivate lazy var selectPhotoBtn: IFEditImageInputBtn = {
         let btn = IFEditImageInputBtn()
         return btn
    }()
    fileprivate lazy var popView: IFHomePop = {
        let popView = IFHomePop()
        popView.transform = CGAffineTransform(scaleX: 0, y: 0)
        return popView
    }()
    fileprivate lazy var successView: IFRecommendTutorialLoadingSuccessView = {
        let successView = IFRecommendTutorialLoadingSuccessView()
        return successView
    }()
    fileprivate lazy var titleHeader: IFFuncChooseSectionHeader = {
        let titleHeader = IFFuncChooseSectionHeader()
        return titleHeader
    }()
    let recomend = IFRecommendTutorialView()
    let pop = IFRecommendStartBtnPop()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(pop)
        pop.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 129, height: 38))
        }

    }
    
    @objc
    fileprivate func showBtnWave() {

        selectPhotoBtn.showWaveAnimation {
            self.popView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
                self.popView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showBtnWave()
    }
    
}


class IFRecommendHeader: UIView {
    fileprivate lazy var photoView: UIView = {
        let photoView = UIView()
        photoView.backgroundColor = .yellow
        return photoView
    }()
    fileprivate lazy var iconView: UIView = {
        let photoView = UIView()
        photoView.backgroundColor = .blue
        return photoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(photoView)
        addSubview(iconView)
       
        photoView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.centerX.equalTo(iconView.snp.centerX)
            $0.size.equalTo(CGSize(width: 400, height: 200))
        }
        iconView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(photoView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension PageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = .orange
        return cell
    }
}

extension PageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UISize.cellHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // y = x /d  + h / d d为滑动的距离
        let dis: CGFloat = tableView.bounds.height - UISize.cellHeight
        let y = (scrollView.contentOffset.y / dis) + UISize.headerH / dis
        print("scrollViewDidScroll: y - \(y) - contentOffset: \(scrollView.contentOffset.y)")
        /**
         向上：header中的photoview变小， iconview变小
         */
        let pTargetSize = CGSize(width: 100, height: 120)
        /// y = (min - max) * x + max
        let photoViewSize = CGSize(width: ((pTargetSize.width - 400) * y) + 400,
                                   height: ((pTargetSize.height - 200) * y) + 200)
        let iconTargetH: CGFloat = 100
        let iconMaxH: CGFloat = 200
        let iconH = ((iconTargetH - iconMaxH) * y) + iconMaxH

        headerView.photoView.snp.updateConstraints {
            $0.size.equalTo(photoViewSize)
        }
        headerView.iconView.snp.updateConstraints {
            $0.height.equalTo(iconH)
        }
        headerView.layoutIfNeeded()
        headerView.frame.size.height = headerView.iconView.frame.maxY
       print("iconH:\(iconH)")
    }
}

class IFRecommendTutorialView: UIView {
    struct UISize {
        static let inset: CGFloat = 20
        static let itemWidth = (UIScreen.main.bounds.width - UISize.inset * 2) / 1.5
        static let itemHeight: CGFloat = itemWidth
        static let titleTop: CGFloat = 16
        static let titleH: CGFloat = 17
        static let subTitleH: CGFloat = 14
        static let subTitleTop: CGFloat = 8
        static let btnSize: CGSize = CGSize(width: 192, height: 52)
        static let totalH = itemHeight + 167
    }
    lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.interitemSpacing = UISize.inset
        pagerView.scrollDirection = .horizontal
        pagerView.isInfinite = false
        pagerView.itemSize = CGSize(width: UISize.itemWidth, height: UISize.itemHeight)
        pagerView.register(IFRecommendTutorialCell.self, forCellWithReuseIdentifier: "IFRecommendTutorialCell")
        return pagerView
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 17, isBold: true)
        label.textColor = UIColor(hex: 0x333333)
        label.text = "超A迷梦光环"
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 17, isBold: true)
        label.textColor = UIColor(hex: 0x808080)
        label.textAlignment = .center
         label.text = "3种不同颜色光环和蝴蝶随意组合"
        return label
     }()
    fileprivate lazy var btn: IFGradientBtn = {
        let btn = IFGradientBtn()
        btn.setTitle("制作同款", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 15.fitiPhone5sSerires, isBold: true)
        btn.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
        btn.normalShadow()
        return btn
    }()
    fileprivate var data: [Int] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pagerView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        let btnContainer = UIView()
        addSubview(btnContainer)
        btnContainer.addSubview(btn)
        pagerView.dataSource = self
        pagerView.snp.makeConstraints {
            $0.left.right.top.equalTo(0)
            $0.height.equalTo(UISize.itemHeight)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(pagerView.snp.bottom).offset(UISize.titleTop)
            $0.height.equalTo(UISize.titleH)
            $0.centerX.equalTo(pagerView.snp.centerX)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(UISize.subTitleTop)
            $0.height.equalTo(UISize.subTitleH)
            $0.centerX.equalTo(pagerView.snp.centerX)
        }
        btnContainer.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        btn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(UISize.btnSize)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func config(_ data: [Int]) {
        self.data = data
        pagerView.reloadData()
    }
}

extension IFRecommendTutorialView: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return data.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "IFRecommendTutorialCell", at: index) as? IFRecommendTutorialCell else {
            return FSPagerViewCell()
        }
        cell.contentView.backgroundColor = UIColor.random
        return cell
    }
}


class IFRecommendTutorialCell: FSPagerViewCell {
    struct UISize {
        static let cornorRadius: CGFloat = 10
    }
    fileprivate lazy var photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.layer.cornerRadius = UISize.cornorRadius
        photoView.layer.masksToBounds = true
        photoView.image = #imageLiteral(resourceName: "before")
        return photoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoView)
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.layer.shadowColor = nil
        contentView.layer.shadowRadius = 0
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = .zero
        photoView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public class IFGradientBtn: UIButton {
    fileprivate var needLayout: Bool = true
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: 0xff64b9)!, UIColor(hex: 0x927cff)!.withAlphaComponent(0.79)].map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if needLayout {
            gradientLayer.cornerRadius = bounds.height * 0.5
            gradientLayer.bounds = bounds
            gradientLayer.opacity = 0.2
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .disabled)
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .highlighted)
            gradientLayer.opacity = 1
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .normal)
            needLayout = false
        }
    }
    
    /// disable时, 阴影 0.2
    public func disableShadow(_ shadowColor: CGColor? = UIColor(hex: 0xd18bf6)!.withAlphaComponent(0.36).cgColor) {
        layer.shadowOffset = CGSize.init(width: 0, height: 6)
        layer.shadowRadius = 15
        layer.shadowOpacity = 1
        layer.shadowColor = shadowColor
    }
    
    /// disable时, 阴影 0.4
    public func normalShadow(_ shadowColor: CGColor = UIColor(hex: 0xd18bf6)!.withAlphaComponent(0.6).cgColor) {
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 15
        layer.shadowOpacity = 1
        layer.shadowColor = shadowColor
    }
    
    public func config(_ handler: ((CAGradientLayer) -> Void)? = nil) {
        handler?(gradientLayer)
    }
    
}


class IFGradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}



class IFEditImageOutRecommedHeader: UIView {
    fileprivate lazy var line: IFGradientView = {
        let line = IFGradientView()
        line.layer.cornerRadius = 1.5
        line.layer.masksToBounds = true
        (line.layer as? CAGradientLayer)?.startPoint = CGPoint(x: 0.5, y: 0)
        (line.layer as? CAGradientLayer)?.endPoint = CGPoint(x: 0.5, y: 1)
        (line.layer as? CAGradientLayer)?.colors = [UIColor(hex: 0xff64b9)!.cgColor, UIColor(hex: 0x927cff)!.withAlphaComponent(0.79).cgColor]
        return line
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "还能快速修出以下效果:"
        label.textColor = UIColor(hex: 0x333333)
        label.font = UIFont.customFont(ofSize: 14, isBold: true)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(line)
        addSubview(titleLabel)
        line.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.height.equalTo(14)
            $0.width.equalTo(3)
            $0.bottom.equalTo(-20)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(line.snp.right).offset(6)
            $0.centerY.equalTo(line.snp.centerY)
        }
        
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}




class IFRecommendTutorialLoadView: UIView {
    struct UISize {
        static let titleH: CGFloat = 13
        static let titleBottom: CGFloat = 12
        static let loadingH: CGFloat = 103
        static let totalH = titleH + titleBottom + loadingH
    }
    var checkProgress: (() -> Void)?
    fileprivate var successAnimationCompletion: (() -> Void)?
    fileprivate var currentProgress: Float = 0
    fileprivate lazy var loadingTexts: [String] = ["图像智能识别中…", "深度对象分析…", "修图建议匹配中…"]
    fileprivate let successtext = "为您推荐使用效果"
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0x808080)
        label.font = UIFont.customFont(ofSize: 13)
        label.transform = CGAffineTransform(scaleX: 0, y: 1)
        return label
    }()
    fileprivate lazy var successView: IFRecommendTutorialLoadingSuccessView = {
        let successView = IFRecommendTutorialLoadingSuccessView()
        successView.alpha = 0
        successView.transform = CGAffineTransform(scaleX: 0, y: 0)
        return successView
    }()
    fileprivate var isAnimate: Bool = false
    /// 帧动画实现
    fileprivate lazy var loadingView: UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    fileprivate var chckTimer: Timer?
    fileprivate var textLoopTimer: Timer?
    fileprivate var currentTextIndex: Int = 0
    fileprivate var isShowSuccess: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loadingView)
        addSubview(titleLabel)
        addSubview(successView)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.height.equalTo(UISize.titleH)
            $0.left.right.equalTo(0)
         }
        loadingView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(UISize.titleBottom)
            $0.height.equalTo(UISize.loadingH)
        }
        successView.snp.makeConstraints {
            $0.centerY.equalTo(loadingView.snp.centerY).offset(-20)
            $0.centerX.equalTo(loadingView.snp.centerX)
            $0.size.equalTo(IFRecommendTutorialLoadingSuccessView.UISize.bgSize)
        }
        loadingView.startAnimating()
        textLoopTimer = Timer(timeInterval: 2, repeats: true, block: {[weak self] (_) in
            guard let weakSelf = self else {
                return
            }
            if weakSelf.isShowSuccess {
                weakSelf.titleLabel.text = weakSelf.successtext
                weakSelf.successAnimation(weakSelf.successAnimationCompletion)
            } else {
                if weakSelf.currentTextIndex >= weakSelf.loadingTexts.count {
                    weakSelf.currentTextIndex = 0
                }
                weakSelf.titleLabel.text = weakSelf.loadingTexts[weakSelf.currentTextIndex]
                weakSelf.currentTextIndex += 1
            }
        })
        RunLoop.main.add(textLoopTimer!, forMode: .common)
        titleLabel.text = loadingTexts[currentTextIndex]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        textLoopTimer?.invalidate()
        chckTimer?.invalidate()
    }
}

extension IFRecommendTutorialLoadView {
    func startLoading(_ progress: Float) {
        if currentProgress > progress {
            return
        }
        if chckTimer != nil {
            chckTimer?.invalidate()
            chckTimer = nil
        }
        chckTimer = Timer(timeInterval: 4, repeats: true) { (_) in
            if progress < 1 {
                /// 去检查一次教程是否拉取成功
                self.checkProgress?()
            }
        }
        RunLoop.main.add(chckTimer!, forMode: .common)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        currentProgress = progress
    }
    
    func showSuccessAnimation(_ completion: (() -> Void)? = nil) {
        if isAnimate {
            return
        }
        isAnimate = true
        successAnimationCompletion = completion
        isShowSuccess = true
    }
    
    fileprivate func successAnimation(_ completion: (() -> Void)? = nil) {
        textLoopTimer?.invalidate()
        textLoopTimer = nil
        UIView.animate(withDuration: 0.25, delay: 1, options: [.curveEaseInOut], animations: {
            self.titleLabel.alpha = 0
        }, completion: nil)
        /// 显示成功的view
        UIView.animate(withDuration: 0.25, delay: 0.25 + 1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.successView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.successView.alpha = 1
        }, completion: { _ in
            self.successView.showStrokeEndAnimation()
            
            /// 完成动画加载完成
            self.successView.hookAnimationComplettion = {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                /// successView加载向下移动，移动的同时，外部教程列表view由下到上出现
                UIView.animate(withDuration: 0.25, delay: 0.5, options: [.curveEaseInOut], animations: {
                    weakSelf.successView.alpha = 0
                    weakSelf.successView.transform = CGAffineTransform(translationX: 0, y: weakSelf.bounds.height * 0.5  + IFRecommendTutorialLoadingSuccessView.UISize.bgSize.height)
                }, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 + 0.15) {
                    completion?()
                }
            }
        })
        
        UIView.animate(withDuration: 0.25, delay: 0.25 + 1, options: [.curveEaseInOut], animations: {
            self.loadingView.alpha = 0
        }, completion: { _ in
            self.loadingView.stopAnimating()
        })
    }
    
    fileprivate func moveSuccessView() {
        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .forwards
        group.beginTime = CACurrentMediaTime() + 0.5
        group.isRemovedOnCompletion = false
        group.duration = 0.25

        let position = CABasicAnimation(keyPath: "position.y")
        position.fromValue = successView.layer.position.y
        position.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        position.fillMode = .forwards
        position.isRemovedOnCompletion = false
        position.setValue("position", forKey: "name")
        position.duration = 0.25
        position.toValue = 1000
        position.delegate = self
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.toValue = 0
        
        group.animations = [position, opacity]
        
        
        (successView.layer as? CAShapeLayer)?.add(position, forKey: "strokeEnd")
        
    }
    
}


extension IFRecommendTutorialLoadView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
           print("animationDidStart")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animationDidStop - finished:\(flag)")
    }
}


class IFRecommendTutorialProgressView: UIView {
    fileprivate lazy var progressView: IFGradientView = {
        let view = IFGradientView()
        view.alpha = 0.8
        (view.layer as? CAGradientLayer)?.startPoint = CGPoint(x: 0, y: 0.5)
        (view.layer as? CAGradientLayer)?.endPoint = CGPoint(x: 1, y: 0.5)
        (view.layer as? CAGradientLayer)?.colors = [UIColor(hex: 0xe88cff)!.cgColor, UIColor(hex: 0x3bc1ff)!.cgColor,]
        view.isHidden = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0x3bc1ff)?.withAlphaComponent(0.2)
        addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.bottom.equalTo(0)
            $0.left.equalTo(0)
            $0.right.equalTo(0)
            $0.top.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func startLoading(_ progress: Float, duration: Double = 3, isFirstLoading: Bool = true, completion: (() -> Void)? = nil) {
        if isFirstLoading {
            progressView.setAnchorPoint(CGPoint(x: 0, y: 0.5))
            self.progressView.transform = CGAffineTransform(scaleX: 0, y: 1)
        }
        progressView.isHidden = false
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.progressView.transform = CGAffineTransform(scaleX: CGFloat(progress), y: 1)
        }, completion: {_ in
            completion?()
        })
    }
}


class IFRecommendTutorialLoadingSuccessView: UIView {
    var hookAnimationComplettion: (() -> Void)?
    struct UISize {
        static let hookSize: CGSize = CGSize(width: 30, height: 30)
        static let mediumSize: CGSize = CGSize(width: 58, height: 58)
        static let bgSize = CGSize(width: 72, height: 72)
    }
    fileprivate lazy var bgView: IFGradientView = {
        let view = IFGradientView()
        view.alpha = 0.35
        (view.layer as? CAGradientLayer)?.startPoint = CGPoint(x: 1, y: 1)
        (view.layer as? CAGradientLayer)?.endPoint = CGPoint(x: 0, y: 0)
        (view.layer as? CAGradientLayer)?.colors = [UIColor(hex: 0xffaae3)!.cgColor, UIColor(hex: 0xcf96ff)!.cgColor,]
        view.layer.cornerRadius = UISize.bgSize.width * 0.5
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var hookView: IFHookView = {
        let hookView = IFHookView()
        let progressLayer = hookView.layer as? CAShapeLayer
        progressLayer?.strokeColor = UIColor.white.cgColor
        progressLayer?.lineWidth = 3.2.fitiPhone5sSerires
        progressLayer?.lineCap = .round
        progressLayer?.fillColor = UIColor.clear.cgColor
        progressLayer?.strokeEnd = 0
        progressLayer?.lineJoin = .bevel
        return hookView
    }()

    fileprivate lazy var mediumView: IFGradientView = {
        let view = IFGradientView()
        (view.layer as? CAGradientLayer)?.startPoint = CGPoint(x: 1, y: 1)
        (view.layer as? CAGradientLayer)?.endPoint =  CGPoint(x: 0, y: 0)
        (view.layer as? CAGradientLayer)?.colors = [UIColor(hex: 0xffaae3)!.cgColor, UIColor(hex: 0xcf96ff)!.cgColor,]
        view.layer.cornerRadius = UISize.mediumSize.width * 0.5
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(mediumView)
        addSubview(hookView)
        bgView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(UISize.bgSize)
        }
        mediumView.snp.makeConstraints {
            $0.center.equalTo(bgView.snp.center)
            $0.size.equalTo(UISize.mediumSize)
        }
        hookView.snp.makeConstraints {
            $0.center.equalTo(mediumView.snp.center)
            $0.size.equalTo(UISize.hookSize)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    /// 打钩动画
    func showStrokeEndAnimation() {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 1
        strokeEnd.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = false
        strokeEnd.setValue("showStrokeEndAnimation", forKey: "name")
        strokeEnd.duration = 0.25
        strokeEnd.delegate = self
        (hookView.layer as? CAShapeLayer)?.add(strokeEnd, forKey: "strokeEnd")
        
    }
}

extension IFRecommendTutorialLoadingSuccessView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String, name == "showStrokeEndAnimation" else {
            return
        }
        hookAnimationComplettion?()
        (hookView.layer as? CAShapeLayer)?.strokeEnd = 1
    }
}


class IFHookView: IFShapeView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5 - 1, y: rect.height * 0.5))
        path.addLine(to: CGPoint(x: rect.width * 0.5 - 1, y: rect.height - 5))
        path.addLine(to: CGPoint(x: rect.width - 2 - 1, y: 8))
        (layer as? CAShapeLayer)?.path = path.cgPath
    }
}

class IFShapeView: UIView {
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
}





class IFGradientCustomBtn: UIButton {
    var outTouchHandler: (() -> Void)?
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isTouchInside {
            outTouchHandler?()
        }
        super.touchesEnded(touches, with: event)
    }
}



class IFShadowView: UIView {
    var shadowColor: CGColor = UIColor.black.withAlphaComponent(0.04).cgColor
    var shadowOpacity: Float = 1
    var shadowOffset: CGSize = CGSize(width: 0, height: 6)
    var shadowRadius: CGFloat = 10
    var cornerRadius: CGFloat = 10
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowPath = path
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 10
    }
    
}
