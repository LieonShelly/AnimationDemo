//
//  FXOvalIView.swift
//  AnimationDemo
//
//  Created by lieon on 2020/8/29.
//  Copyright © 2020 lieon. All rights reserved.
//

import UIKit

class FXOvalIView: UIView {
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let layer = self.layer as? CAShapeLayer
        layer?.lineWidth = 2
        layer?.fillColor = UIColor(hex: 0x6970ff)!.withAlphaComponent(0.53).cgColor
        layer?.strokeColor = UIColor(hex: 0x56bbff)!.cgColor
        let path = UIBezierPath(ovalIn: bounds).cgPath
        layer?.path = path
    }
}

class FXShapeView: UIView {
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
}

class FX3DLightMoveLightPanel: UIView {
    fileprivate var pathView: FXShapeView = {
        let view = FXShapeView()
        let layer = view.layer as? CAShapeLayer
        layer?.lineWidth = 2
        layer?.fillColor = UIColor.clear.cgColor
        layer?.strokeColor = UIColor.red.cgColor
        return view
    }()
    fileprivate lazy var ovalView: FXOvalIView = {
        let ovalView = FXOvalIView()
        ovalView.layer.opacity = 0
        return ovalView
    }()
    var nosePoint: CGPoint?
    var scaleYMin: CGFloat = 0.3
    var scaleYMax: CGFloat = 1
    var scaleXmin: CGFloat = 0.3
    var scaleXmax: CGFloat = 1
    var radius: CGFloat = 80
    var superPath: UIBezierPath?
    fileprivate var startPoint: CGPoint = .zero
    fileprivate var ovalRect: CGRect?
    fileprivate var ovalPathAllPoints: [CGPoint] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pathView)
        ovalView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addSubview(ovalView)
        nosePoint = CGPoint.zero
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        pathView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func moveEnd() {
        startPoint = ovalView.center
    }
    
    func showAnimation() {
        let btnScale = CAKeyframeAnimation(keyPath: "opacity")
        btnScale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        btnScale.fillMode = .forwards
        btnScale.isRemovedOnCompletion = false
        btnScale.delegate = self
        btnScale.duration = 1.5
        btnScale.setValue("showAnimation", forKey: "name")
        btnScale.values = [0, 1, 0]
        ovalView.layer.add(btnScale, forKey: nil)
    }
    
    func configSuperPath(_ rect: CGRect, nosePoint: CGPoint) {
        superPath = UIBezierPath(ovalIn: rect)
        self.nosePoint = nosePoint
        ovalView.center = nosePoint
        (pathView.layer as? CAShapeLayer)?.path = superPath?.cgPath
        startPoint = nosePoint
        ovalRect = rect
        radius = rect.width * 0.5
        ovalPathAllPoints.append(contentsOf: ovalPathAllPoints(rect, nosePoint: nosePoint))
        print("ovalPathAllPoints:\(ovalPathAllPoints.count)")
    }
    
    func updateLocation(_ deltaX: CGFloat, deltaY: CGFloat) {
        var point = CGPoint(x: startPoint.x + deltaX, y:  startPoint.y + deltaY)
        guard let nosePoint = nosePoint else {
            return
        }
        guard let superPath = superPath else {
            return
        }
        if !superPath.contains(point) {
            let OA = sqrt((point.x - nosePoint.x) * (point.x - nosePoint.x) + (point.y - nosePoint.y) * (point.y - nosePoint.y))
            let yb = (point.y - nosePoint.y) * radius / OA + nosePoint.y
            let xb = nosePoint.x +  (point.x - nosePoint.x) * radius / OA
            point = CGPoint(x: xb, y: yb)
        }
        ovalView.center = point
        let distanceY  = abs(point.y - nosePoint.y)
        let distanceX  = abs(point.x - nosePoint.x)
        
        let angleMax: CGFloat = .pi / 3
        let angleMin: CGFloat = 0
        let angleXMax: CGFloat = .pi / 2.5
        let angleXMin: CGFloat = 0
        
        var angleY = (angleMax - angleMin) * distanceX / radius + angleMin;
        var angleX = (angleXMax - angleXMin) * distanceY / radius + angleXMin;
        if angleY > angleMax {
            angleY = angleMax
        }
        if angleX > angleMax {
            angleX = angleMax
        }
        if angleY < angleMin {
            angleY = angleMin
        }
        if angleX < angleMin {
            angleX = angleMin
        }
        // 判断象限
        // 第一象限
        if nosePoint.x < point.x && nosePoint.y > point.y {
            let rotateY = CATransform3DMakeRotation(angleY, 0, 1, 0)
            let rotateX = CATransform3DMakeRotation(angleX, 1, 0, 0)
            ovalView.layer.transform = CATransform3DConcat(rotateX, rotateY)
        } else if nosePoint.x > point.x && nosePoint.y > point.y { // 第二象限
            let rotateY = CATransform3DMakeRotation(.pi - angleY, 0, 1, 0)
            let rotateX = CATransform3DMakeRotation(.pi - angleX, 1, 0, 0)
            ovalView.layer.transform = CATransform3DConcat(rotateX, rotateY)
        } else if nosePoint.x > point.x && nosePoint.y < point.y { // 第三象限
            let rotateY = CATransform3DMakeRotation(angleY, 0, 1, 0)
            let rotateX = CATransform3DMakeRotation(angleX, 1, 0, 0)
            ovalView.layer.transform = CATransform3DConcat(rotateX, rotateY)
        } else  if nosePoint.x < point.x && nosePoint.y < point.y { // 第四象限
            let rotateY = CATransform3DMakeRotation(.pi - angleY, 0, 1, 0)
            let rotateX = CATransform3DMakeRotation(.pi - angleX, 1, 0, 0)
            ovalView.layer.transform = CATransform3DConcat(rotateX, rotateY)
        }
    }
    
    func ovalPathAllPoints(_ ovalRect: CGRect, nosePoint: CGPoint) -> [CGPoint] {
        let a = ovalRect.height * 0.5
        let b = ovalRect.width * 0.5
        /**
         椭圆公式 (y - nosePoint.y) / a * a  + (x - nosePoint.x) / b * b = 1
         直线公式 y = point.y * x / point.x
         */
        let xmin = ovalRect.minX
        let xMax = ovalRect.maxX
        var allPoints: [CGPoint] = []
        for x in stride(from: xmin, to: xMax, by: 1) {
            let y1 = sqrt((a * a * b * b - a * a * (x - nosePoint.x) * (x - nosePoint.x)) / (b * b)) + nosePoint.y
            let y2 = -sqrt((a * a * b * b - a * a * (x - nosePoint.x) * (x - nosePoint.x)) / (b * b)) + nosePoint.y
            allPoints.append(CGPoint(x: x, y: y1))
            allPoints.append(CGPoint(x: x, y: y2))
        }
        allPoints.sort { (point1, point2) -> Bool in
            return point1.x > point2.x && point1.y > point2.y
        }
        return allPoints
    }
    
    func minDistancePoint(_ point: CGPoint, _ ovalRect: CGRect, nosePoint: CGPoint) {
        print("point:\(point)")
        let point = CGPoint(x: mapValue(point.x, mapMaxV: 1, mapMinV: 0, uiMaxV: UIScreen.main.bounds.width, uiMinV: 0),
                            y: mapValue(point.y, mapMaxV: 1, mapMinV: 0, uiMaxV: UIScreen.main.bounds.height, uiMinV: 0))
        let nosePoint = CGPoint(x: mapValue(nosePoint.x, mapMaxV: 1, mapMinV: 0, uiMaxV: UIScreen.main.bounds.width, uiMinV: 0),
                                y: mapValue(nosePoint.y, mapMaxV: 1, mapMinV: 0, uiMaxV: UIScreen.main.bounds.height, uiMinV: 0))
        let ovalRect = CGRect(x:  mapValue(ovalRect.origin.x, mapMaxV: 1, mapMinV: 0, uiMaxV: UIScreen.main.bounds.width, uiMinV: 0),
                              y:  mapValue(ovalRect.origin.y, mapMaxV: 1, mapMinV: 0, uiMaxV: UIScreen.main.bounds.height, uiMinV: 0),
                              width:  mapValue(ovalRect.width, mapMaxV: 1, mapMinV: 0, uiMaxV: UIScreen.main.bounds.width, uiMinV: 0),
                              height:  mapValue(ovalRect.height, mapMaxV: 1, mapMinV: 0, uiMaxV: UIScreen.main.bounds.height, uiMinV: 0))
        let a = ovalRect.height * 0.5
        let b = ovalRect.width * 0.5
        let k = point.y / point.x
        let A = b * k * k + a
        let B = -(2 * b * nosePoint.y * k + 2 * a * nosePoint.x)
        let C = b * nosePoint.y * nosePoint.y + a * nosePoint.x * nosePoint.x - a * b
        
        let x = (-B + sqrt(B * B - 4 * A * C)) / (2 * A)
        let y = k * x
        let point0 = CGPoint(x: x, y: y)
        print(point0)
    }
    
    fileprivate func mapValue(_ inputValue: CGFloat, mapMaxV: CGFloat, mapMinV: CGFloat, uiMaxV: CGFloat, uiMinV: CGFloat) -> CGFloat {
        let realV: CGFloat = ((mapMaxV - mapMinV) * (inputValue - uiMinV) / (uiMaxV - uiMinV)) + mapMinV
        return realV
    }
}

extension FX3DLightMoveLightPanel: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
}

extension CGFloat {
    var  intFloat:  CGFloat {
        return CGFloat(Int(self))
    }
}
