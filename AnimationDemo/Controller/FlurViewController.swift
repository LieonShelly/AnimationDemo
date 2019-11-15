//
//  FlurViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/11/14.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import SnapKit

class FlurViewController: UIViewController {
     
    @IBAction func bgColorSliderAction(_ sender: UISlider) {
        customView.backgroundColor = UIColor(hex: 0x949494)!.withAlphaComponent(CGFloat(sender.value))
         colorBlur.backgroundColor = UIColor(hex: 0x949494)!.withAlphaComponent(CGFloat(sender.value))
    }
    
    @IBAction func aphaSliderAction(_ sender: UISlider) {
        customView.setBlurRadius(radius: CGFloat(sender.value * 100))
         colorBlur.backgroundColor = UIColor(hex: 0x949494)!.withAlphaComponent(CGFloat(sender.value))
    }
    
    
    
    let customView = APCustomBlurView(withRadius: 10)
    let colorBlur = ColorfulBlurEffectView(effect: UIBlurEffect(style: .light))
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0,
                                            y: 100,
                                        width: UIScreen.main.bounds.width,
                                        height: 0.5)
        gradientLayer.colors = [
                UIColor(hex: 0x54d5ef)!.cgColor,
                UIColor(hex: 0x54ecef)!.cgColor,
                UIColor(hex: 0xd79afb)!.cgColor,
                UIColor(hex: 0xff82ff)!.cgColor,
                UIColor(hex: 0xd795fb)!.cgColor,
                UIColor(hex: 0x54d5ef)!.cgColor,
                UIColor(hex: 0x54d5ef)!.cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0, 0.16, 0.4, 0.5, 0.61, 0.83, 1]

        view.addSubview(customView)
        view.addSubview(colorBlur)
        
        customView.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.height.equalTo(100)
            $0.top.equalTo(0)
        }
        
//        colorBlur.snp.makeConstraints {
//            $0.left.right.equalTo(0)
//            $0.height.equalTo(100)
//            $0.top.equalTo(customView.snp.bottom)
//        }
        customView.layer.addSublayer(gradientLayer)
    }
}


public class APCustomBlurView: UIVisualEffectView {
    
    private let blurEffect: UIBlurEffect
    public var blurRadius: CGFloat {
        return blurEffect.value(forKey: "blurRadius") as! CGFloat
    }
    
    public convenience init() {
        self.init(withRadius: 0)
    }
    
    public init(withRadius radius: CGFloat) {
        let customBlurClass: AnyObject.Type = NSClassFromString("_UICustomBlurEffect")!
        let customBlurObject: NSObject.Type = customBlurClass as! NSObject.Type
        self.blurEffect = customBlurObject.init() as! UIBlurEffect
        self.blurEffect.setValue(1.0, forKeyPath: "scale")
        self.blurEffect.setValue(radius, forKeyPath: "blurRadius")
        super.init(effect: radius == 0 ? nil : self.blurEffect)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setBlurRadius(radius: CGFloat) {
        guard radius != blurRadius else {
            return
        }
        blurEffect.setValue(radius, forKeyPath: "blurRadius")
        self.effect = blurEffect
    }
    
}


open class ColorfulBlurEffectView: UIVisualEffectView {

    fileprivate let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    open var colorTint: UIColor? {
        get { return _value(forKey: "colorTint") as? UIColor }
        set { _setValue(newValue, forKey: "colorTint") }
    }
    
    /// 默认 0
    open var colorTintAlpha: CGFloat {
        get { return _value(forKey: "colorTintAlpha") as! CGFloat }
        set { _setValue(newValue, forKey: "colorTintAlpha") }
    }
    
    /// 默认 0
    open var blurRadius: CGFloat {
        get { return _value(forKey: "blurRadius") as! CGFloat }
        set { _setValue(newValue, forKey: "blurRadius") }
    }
    
    /// 默认 1.0
    open var scale: CGFloat {
        get { return _value(forKey: "scale") as! CGFloat }
        set { _setValue(newValue, forKey: "scale") }
    }
    
    
    public override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        prepare()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepare()
    }
    
    fileprivate func prepare() {
        scale = 1
    }

}


extension ColorfulBlurEffectView {
    
    fileprivate func _value(forKey key: String) -> Any? {
        return blurEffect.value(forKeyPath: key)
    }
    
    fileprivate func _setValue(_ value: Any?, forKey key: String) {
        blurEffect.setValue(value, forKeyPath: key)
        self.effect = blurEffect
    }
    
}
