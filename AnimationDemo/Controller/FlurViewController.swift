//
//  FlurViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/14.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class FlurViewController: UIViewController {
    @IBOutlet weak var gradientView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        gradientView.colors = [UIColor.white.withAlphaComponent(0),
//                               UIColor.white.withAlphaComponent(0.06),
//                               UIColor.white.withAlphaComponent(0.49),
//                               UIColor.white.withAlphaComponent(0.76),
//                               UIColor.white.withAlphaComponent(0.9),
//                                UIColor.white.withAlphaComponent(1), ]
//        gradientView.colors = [UIColor.green.withAlphaComponent(0.5), .yellow]
//        gradientView.locations = [0.2, 0.4, 0.6, 0.8, 1]
//        gradientView.direction = .vertical
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = gradientView.bounds
//        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor,
//        UIColor.white.withAlphaComponent(0.06).cgColor,
//        UIColor.white.withAlphaComponent(0.49).cgColor,
//        UIColor.white.withAlphaComponent(0.76).cgColor,
//        UIColor.white.withAlphaComponent(0.9).cgColor,
//         UIColor.white.withAlphaComponent(1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//        gradientLayer.locations = [0.2, 0.4, 0.6, 0.8, 1]
//        gradientView.layer.addSublayer(gradientLayer)
        let testView = FXTutorialLaunchPanel()
        view.addSubview(testView)
        testView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }


}

//
//  GradientButton.swift
//  InFace
//
//  Created by 权欣权忆 on 2019/6/6.
//  Copyright © 2019 Pinguo. All rights reserved.
//

import UIKit

public enum GradientButtonShadowType: Int {
    case none
    case normal
    case gradient
}

public class GradientButton: UIButton {
    
    var gradientColors: [UIColor] = []
    var shadowColor: UIColor?
    var shadowRadius: CGFloat = 20
    var shadowOpacity: CGFloat = 0.4
    var cornerRadius: CGFloat = 0.0
    var shadowOffset: CGSize = CGSize.init(width: 0, height: 10)
    var showBottomShadow: GradientButtonShadowType = .none
    
    var layoutedSubviews: Bool = false
    var layoutedSublayers: Bool = false
    var lastBounds: CGRect = CGRect.zero // bob 2019-07-29 如果按钮的大小变化了，需要更新背景
    
    /** 是否展示渐变边框，中间镂空 */
    private(set) var isBouderOut: Bool = false
    private var borderLayer: CAGradientLayer?
    
    private lazy var bottomShadowLayer: CALayer = {
        $0.contentsScale = UIScreen.main.scale
        $0.contents = UIImage.init(named: "bottom_shadow")?.cgImage
        return $0
    }(CALayer.init())
    
    public convenience init(button type: ButtonType,
                            showBottom shadow: GradientButtonShadowType = .normal,
                            corner radius: CGFloat = 10.0,
                            gradient colors: [UIColor] = [UIColor.init(hex: 0x7AD3FF)!,
                                                          UIColor.init(hex: 0xE261DD)!],
                            shadow color: UIColor? = UIColor.init(hex: 0xB196ED),
                            shadowRadius: CGFloat = 20,
                            shadowOpacity: CGFloat = 0.4,
                            shadowOffset: CGSize = CGSize.init(width: 0, height: 10),
                            borderOut: Bool = false) {
        self.init(type: type)
        gradientColors = colors
        cornerRadius = radius
        showBottomShadow = shadow
        shadowColor = color
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        isBouderOut = borderOut
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isBouderOut && (!layoutedSubviews || !lastBounds.equalTo(bounds)) {
            layoutedSubviews = true
            lastBounds = bounds
            let gradientLayer: CAGradientLayer = CAGradientLayer.init()
            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = cornerRadius
            gradientLayer.colors = gradientColors.map{$0.cgColor}
            gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
            
            // bob 添加集中状态的效果与设计一致
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .normal)
            gradientLayer.opacity = 0.5
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .highlighted)
            gradientLayer.opacity = 0.2
            setBackgroundImage(UIImage.imageFrom(layer: gradientLayer), for: .disabled)
        }
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if isBouderOut {
            if layer == self.layer {
                let rect = layer.bounds
                
                if borderLayer == nil {
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.borderWidth = 1
                    shapeLayer.masksToBounds = true
                    shapeLayer.cornerRadius = cornerRadius
                    
                    let gradientLayer = CAGradientLayer()
                    gradientLayer.colors = gradientColors.map{ $0.cgColor }
                    gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
                    gradientLayer.mask = shapeLayer
                    borderLayer = gradientLayer
                    self.layer.addSublayer(gradientLayer)
                }
                
                borderLayer?.frame = rect
                borderLayer?.mask?.frame = rect
            }
        } else if !layoutedSublayers || !lastBounds.equalTo(bounds) {
            layoutedSublayers = true
            switch showBottomShadow {
            case .gradient:
                bottomShadowLayer.frame = CGRect.init(x: 0, y: bounds.size.height - 2, width: bounds.size.width, height: 7.0)
                layer.insertSublayer(bottomShadowLayer, at: 0)
            case .normal:
                layer.shadowOffset = shadowOffset
                layer.shadowRadius = shadowRadius
                layer.shadowOpacity = Float(shadowOpacity)
                layer.shadowColor = shadowColor?.cgColor
            default:
                break
            }
        }
    }
}

internal extension UIImage {
    static func imageFrom(layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size,
                                               layer.isOpaque,
                                               UIScreen.main.scale)
        
        defer { UIGraphicsEndImageContext() }
        
        // Don't proceed unless we have context
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}



class FXTutorialLaunchPanel: UIView {
    struct UISize {
        static let contentViewCornorRadius: CGFloat = 20.0.fit375Pt
        static let existBtnTop: CGFloat = contentViewCornorRadius + 46
        static let gradientHeight: CGFloat = 127.0.fit375Pt
        static let coverViewHeight: CGFloat = 127.0.fit375Pt + 67.0.fit375Pt
        static let iconHeight: CGFloat = 64
        static let tagHeight: CGFloat = 16
        static let teacherLabelHeight: CGFloat = 21
        static let titleLabeHeight: CGFloat = 28
        static let startBtnHeight: CGFloat = 46
        static let vipDescHeight: CGFloat = 17
        static let existeBtnSzie: CGSize = CGSize(width: 92, height: 36)
        
    }
    fileprivate lazy var bottomFlurView: UIVisualEffectView = {
       let view = UIVisualEffectView()
        view.alpha = 0.8
        let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        view.effect = effect
        return view
    }()
    
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UISize.contentViewCornorRadius
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var bgView: UIImageView = {
        let bgView = UIImageView()
        bgView.contentMode = .scaleToFill
        bgView.image = UIImage(named: "sd")
        bgView.backgroundColor = .red
        return bgView
    }()
    fileprivate lazy var coverView: UIImageView = {
        let bgView = UIImageView()
        bgView.contentMode = .scaleToFill
        bgView.image = UIImage(named: "sd")
        bgView.backgroundColor = .red
        return bgView
    }()
    fileprivate lazy var iconView: UIImageView = {
        let bgView = UIImageView()
        bgView.layer.cornerRadius = UISize.iconHeight * 0.5
        bgView.backgroundColor = .blue
        return bgView
    }()
    fileprivate lazy var nameTagView: UIImageView = {
        let bgView = UIImageView()
        bgView.backgroundColor = .red
        return bgView
    }()
    fileprivate lazy var teacherLabel: UILabel = {
        let bgView = UILabel()
        bgView.text = "yadfadsf"
        bgView.font = UIFont.systemFont(ofSize: 15)
        bgView.textColor = .black
        bgView.textAlignment = .center
        return bgView
    }()
    fileprivate lazy var descLabel: UILabel = {
        let bgView = UILabel()
        bgView.text = "动感模糊一秒P掉路人，让你的照片更干净"
        bgView.font = UIFont.systemFont(ofSize: 14)
        bgView.textAlignment = .center
        bgView.textColor = .gray
        return bgView
    }()
    fileprivate lazy var titleLabel: UILabel = {
         let bgView = UILabel()
         bgView.text = "拯救废片必备技能"
         bgView.textAlignment = .center
         bgView.font = UIFont.boldSystemFont(ofSize: 20)
         bgView.textColor = .black
         return bgView
     }()
    
    fileprivate lazy var vipdescLabel: UILabel = {
        let bgView = UILabel()
        bgView.text = "VIP功能仅支持会员使用"
        bgView.font = UIFont.systemFont(ofSize: 12)
        bgView.textColor = UIColor(hex: 0xe261dd)
        return bgView
    }()
    
    fileprivate lazy var vipIconView: UIImageView = {
        let bgView = UIImageView()
        bgView.backgroundColor = .red
        return bgView
    }()
    
    fileprivate lazy var startBtn: GradientButton = {
        let btn = GradientButton(type: .custom)
        btn.gradientColors = [UIColor(hex: 0x7ad3ff)!, UIColor(hex: 0xff41d3)!]
        btn.cornerRadius = 8
        btn.setTitle("开始", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return btn
    }()
    
    fileprivate lazy var existBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 18
        btn.clipsToBounds = true
        btn.setTitle("退出教程", for: .normal)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

extension FXTutorialLaunchPanel {
    fileprivate func configUI() {
        addSubview(bgView)
        addSubview(bottomFlurView)
        addSubview(contentView)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0,
                                     y: UISize.existBtnTop + UISize.existeBtnSzie.height * 0.5,
                                 width: UIScreen.main.bounds.width,
                                 height: UISize.coverViewHeight + UISize.contentViewCornorRadius -  UISize.existBtnTop + UISize.existeBtnSzie.height * 0.5)
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor,
                                UIColor.white.withAlphaComponent(0.2).cgColor,
                                UIColor.white.withAlphaComponent(0.49).cgColor,
                                UIColor.white.withAlphaComponent(0.76).cgColor,
                                UIColor.white.withAlphaComponent(0.9).cgColor,
                                UIColor.white.withAlphaComponent(1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.2, 0.4, 0.6, 0.8, 1]
     
        contentView.addSubview(coverView)
        contentView.layer.addSublayer(gradientLayer)
        contentView.addSubview(iconView)
        contentView.addSubview(teacherLabel)
        contentView.addSubview(nameTagView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(startBtn)
        contentView.addSubview(vipIconView)
        contentView.addSubview(vipdescLabel)
        contentView.addSubview(existBtn)
        
        bgView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
        bottomFlurView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        contentView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(-UISize.contentViewCornorRadius)
            $0.height.greaterThanOrEqualTo(UISize.gradientHeight)
        }
        
        coverView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.top.equalTo(UISize.contentViewCornorRadius)
            $0.height.equalTo(UISize.coverViewHeight)
        }
        
        existBtn.snp.makeConstraints {
            $0.top.equalTo(UISize.existBtnTop)
            $0.size.equalTo(UISize.existeBtnSzie)
            $0.right.equalTo(-20)
        }
        
        iconView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: UISize.iconHeight, height: UISize.iconHeight))
            $0.centerX.equalTo(coverView.snp.centerX)
            $0.centerY.equalTo(coverView.snp.bottom).offset(-10)
        }
        
        teacherLabel.snp.makeConstraints {
            $0.centerX.equalTo(iconView.snp.centerX).offset(10)
            $0.height.equalTo(UISize.teacherLabelHeight)
            $0.top.equalTo(iconView.snp.bottom).offset(10)
            $0.left.greaterThanOrEqualTo(20)
            $0.right.lessThanOrEqualTo(-20)
        }
        
        nameTagView.snp.makeConstraints {
            $0.centerY.equalTo(teacherLabel.snp.centerY)
            $0.height.equalTo(UISize.tagHeight)
            $0.width.equalTo(UISize.tagHeight)
            $0.right.equalTo(teacherLabel.snp.left).offset(-3)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(iconView.snp.centerX)
            $0.height.equalTo(UISize.titleLabeHeight)
            $0.top.equalTo(teacherLabel.snp.bottom).inset(-16)
            $0.left.equalTo(20)
        }
        
        descLabel.snp.makeConstraints {
            $0.centerX.equalTo(iconView.snp.centerX)
            $0.top.equalTo(titleLabel.snp.bottom).inset(-10)
            $0.left.right.equalTo(contentView).inset(30)
        }
        
        startBtn.snp.makeConstraints {
             $0.centerX.equalTo(iconView.snp.centerX)
             $0.height.equalTo(UISize.startBtnHeight)
             $0.width.equalTo(238)
             $0.top.equalTo(descLabel.snp.bottom).inset(-24)
             $0.bottom.equalTo(-52)
         }
        
        vipdescLabel.snp.makeConstraints {
            $0.centerX.equalTo(iconView.snp.centerX)
            $0.height.equalTo(UISize.vipDescHeight)
            $0.top.equalTo(startBtn.snp.bottom).inset(-8)
        }
        
       vipIconView.snp.makeConstraints {
          $0.centerY.equalTo(vipdescLabel.snp.centerY)
          $0.height.equalTo(UISize.tagHeight)
          $0.width.equalTo(UISize.tagHeight)
          $0.right.equalTo(vipdescLabel.snp.left).offset(-3)
      }
    }
}


