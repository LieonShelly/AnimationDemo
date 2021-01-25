//
//  BtnViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/25.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BtnViewController: UIViewController {
    var destinationRect = CGRect(x: UIScreen.main.bounds.width - 100, y: 100, width: 44, height: 44)
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [#colorLiteral(red: 0.4784313725, green: 0.8274509804, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.2549019608, blue: 0.8274509804, alpha: 1).cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    let bag = DisposeBag()
    lazy var shapeLapyer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        return shapeLayer
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dashView = DashView(frame: CGRect(x: 40, y: 400, width: 16, height: 22))
        dashView.backgroundColor = UIColor.red
        view.addSubview(dashView)
        let label0 = UILabel()
        label0.text = "1"
        label0.textColor = .white
        label0.font = UIFont.boldSystemFont(ofSize: 11)
        
        let label1 = UILabel()
        label1.text = "2"
        label1.textColor = .white
        label1.font = UIFont.boldSystemFont(ofSize: 11)
        dashView.addSubview(label0)
        dashView.addSubview(label1)
        label0.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.left.equalTo(1)
        }
        label1.snp.makeConstraints {
             $0.bottom.equalTo(2)
             $0.right.equalTo(-2)
        }
        
        let btn = UIButton(type: .custom)
        let btnBounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        btn.frame.size = btnBounds.size
        btn.center = view.center
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 30
        btn.layer.shadowPath = CGPath(roundedRect: btnBounds,
                                      cornerWidth: 30,
                                      cornerHeight: 30, transform: nil)
        btn.layer.shadowColor = UIColor.red.cgColor
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 10
        btn.layer.shadowOpacity = 1
        view.addSubview(btn)
        
        let layerAnimation = CABasicAnimation(keyPath: "shadowRadius")
        layerAnimation.fromValue = 10
        layerAnimation.toValue = 1
        layerAnimation.autoreverses = true
        layerAnimation.isAdditive = false
        layerAnimation.duration = 0.25
        layerAnimation.fillMode = .forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.repeatCount = .infinity
        btn.layer.add(layerAnimation, forKey: nil)
        
        shapeLapyer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: destinationRect.height, height: destinationRect.height), cornerRadius: destinationRect.height * 0.5).cgPath
        shapeLapyer.lineWidth = 5
        gradientLayer.frame = destinationRect
        gradientLayer.removeAllAnimations()
        gradientLayer.mask = shapeLapyer
        gradientLayer.cornerRadius = destinationRect.height * 0.5
        view.layer.addSublayer(gradientLayer)
        btn.setTitle("Alert", for: .normal)
        btn.rx.tap
            .subscribe(onNext: { (_) in
                let alert = FXTutorialHandlerAlert(.common(FXTutorialHandlerAlert.AlertData(iconURL: nil, title: "第一步：照片调色", desc: "调整照片为单色调，营造复古感调整照片为单色调，营造复古感调整照片为单色调，营造复古感", buttonTiitle: "sadf", destionationRect: .zero)))
                alert.show { (_) in
                    
                }
            })
            .disposed(by: bag)
    }
    
}

extension Bundle {
    static func getFilePath(fileName: String,
                            fileType: String = "png") -> String {
        if let str =  Bundle.main.path(forResource: fileName + "@3x", ofType: fileType) {
            return str
        } else if let str = Bundle.main.path(forResource: fileName, ofType: fileType) {
            return str
        }
        return ""
    }
}

extension Double {
    var fitiPhone5sSerires: CGFloat {
        let deviceWidth = UIScreen.main.bounds.width
        if deviceWidth <= 640 * 0.5 { // 5s
            return fit375Pt
        } else {
            return CGFloat(self)
        }
    }
}

public extension UIFont {
    
    enum UIFontNameSpecs: String {
        case regular = "PingFangSC-Regular"
        case medium = "PingFangSC-Medium"
        case bold = "PingFangSC-Semibold"
    }
    
    /** 常规 */
    static let def_fontName: String = UIFontNameSpecs.regular.rawValue
    /** 中等粗 */
    static let def_fontName_medium: String = UIFontNameSpecs.medium.rawValue
    /** 粗体 - 使用较少 */
    static let def_fontName_bold: String = UIFontNameSpecs.bold.rawValue
    
    /// 外部自己控制是否应用机型适配值
    static func customFontOffsetAdapt(ofSize: CGFloat, isBold: Bool = false) -> UIFont {
        let fontName = isBold ? def_fontName_medium : def_fontName
        
        if let font = UIFont.init(name: fontName, size: ofSize) {
            return font
        }
        
        return UIFont.systemFont(ofSize: ofSize)
    }
    
    static func customFont(ofSize: CGFloat, isBold: Bool) -> UIFont {
        return customFont(def_fontName, ofSize: ofSize, isBold: isBold)
    }
    
    static func customFont(ofSize: CGFloat, spec: UIFontNameSpecs) -> UIFont {
        return customFont(spec.rawValue, ofSize: ofSize, isBold: false)
    }
    
    static func customFont(_ name: String = def_fontName, ofSize: CGFloat, isBold: Bool = false) -> UIFont {
        let fontName = (isBold && name == def_fontName) ? def_fontName_medium : name
        
        if let font = UIFont.init(name: fontName, size: ofSize.adaptedValue()) {
            return font
        }
        
        return UIFont.systemFont(ofSize: ofSize.adaptedValue())
    }
    
}


class DashView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let pth = UIBezierPath()
        let start = CGPoint(x: rect.width - 2, y: 2)
        let end = CGPoint(x: 2, y: rect.height - 2)
        pth.move(to: start)
        pth.addLine(to: end)
        pth.lineWidth = 2
        UIColor.white.setStroke()
        UIColor.clear.setFill()
        pth.stroke()
    }
}
