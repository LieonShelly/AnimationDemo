//
//  ClipViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2021/1/7.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit

class ClipViewController: UIViewController {
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_free_alert_bg")
        return imageView
    }()
    fileprivate lazy var oriImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageView)
        let bgSize = CGSize(width: 310, height: 344)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(bgSize)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vcc = IFFreeChanceAlert()
        vcc.display(willShow: nil, didShow: nil, willDismiss: nil, didDismiss: nil)
    }
    
}

extension UIImage {
    func imageClip(rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 1.0)
        var clipRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        clipRect.origin.y = -rect.minY
        clipRect.origin.x = -rect.minX
        
        self.draw(in: clipRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func imageFill(rect: CGRect, contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 1.0)
        guard let _ = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        let drawRect = UIImage.caculateFitRect(model: contentMode, canvasSize: rect.size, fitSize: size)
        self.draw(in: drawRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func caculateFitRect(model: UIView.ContentMode, canvasSize: CGSize, fitSize: CGSize) -> CGRect {
        let si = fitSize
        let size = canvasSize
        var rect = CGRect(x: 0, y: 0, width: si.width, height: si.height)
        switch model {
            case .scaleToFill:
                rect.size = size
            case .scaleAspectFit:
                if size.width/size.height > si.width/si.height {
                    // 高度优先
                    rect.size.height = size.height
                    rect.size.width = si.width * size.height / si.height
                } else {
                    // 宽度优先
                    rect.size.width = size.width
                    rect.size.height = si.height * size.width / si.width
                }
                
                rect.origin.x = (size.width-rect.size.width)/2
                rect.origin.y = (size.height-rect.size.height)/2
            case .scaleAspectFill:
                if size.width/size.height > si.width/si.height {
                    // 宽度优先
                    rect.size.width = size.width
                    rect.size.height = si.height * size.width / si.width
                } else {
                    // 高度优先
                    rect.size.height = size.height
                    rect.size.width = si.width * size.height / si.height
                }
                
                rect.origin.x = (size.width-rect.size.width)/2
                rect.origin.y = (size.height-rect.size.height)/2
            case .top:
                rect.origin.x = (size.width-rect.size.width)/2
            case .topRight:
                rect.origin.x = size.width-rect.size.width
            case .left:
                rect.origin.y = (size.height-rect.size.height)/2
            case .center:
                rect.origin.x = (size.width-rect.size.width)/2
                rect.origin.y = (size.height-rect.size.height)/2
            case .right:
                rect.origin.x = size.width-rect.size.width
                rect.origin.y = (size.height-rect.size.height)/2
            case .bottomLeft:
                rect.origin.y = size.height-rect.size.height
            case .bottom:
                rect.origin.x = (size.width-rect.size.width)/2
                rect.origin.y = size.height-rect.size.height
            case .bottomRight:
                rect.origin.x = size.width-rect.size.width
                rect.origin.y = size.height-rect.size.height
            default:
                break
        }
        
        return rect
    }
}

// 5472/4648 = 1.17

// 1078/719 = 1.49
