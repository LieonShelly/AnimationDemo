
//
//  TouchView.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/11.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class TouchView: UIView {
    var currentHandlePoints: [CGPoint] = []
    lazy var path: UIBezierPath = UIBezierPath()
    fileprivate lazy var allPath: [UIBezierPath] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addGesture()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
      
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        UIColor.yellow.setStroke()
        path.stroke()
    }
    
    func clear() {
        allPath.removeAll()
        path = UIBezierPath()
        setNeedsDisplay()
    }
}

extension TouchView {
    fileprivate func createShapLayer() -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.strokeColor = UIColor.yellow.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineJoin = .round
        shape.lineCap = .round
        shape.lineWidth = 20
        shape.frame = bounds
        return shape
    }
    
    fileprivate func createPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 10
        return path
    }
    
    fileprivate func addGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(_:)))
        addGestureRecognizer(pan)
        
    }
    
    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        let location = pan.location(in: self)
        switch pan.state {
        case .began:
            let path = createPath()
            path.move(to: location)
            self.path = path
            currentHandlePoints.removeAll()
            allPath.append(path)
            currentHandlePoints.append(location)
        case .changed:
            path.addLine(to: location)
            setNeedsDisplay()
            currentHandlePoints.append(location)
        default:
            break
        }
    }
    
}

class TouchRecordView: TouchView {
    fileprivate lazy var dot: UIView = {
         let dot = UIView()
         return dot
     }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addot()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addot()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func addot() {
        dot.bounds.size = CGSize(width: 20, height: 20)
        dot.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        dot.layer.cornerRadius = 10
        dot.layer.borderColor =  UIColor.lightGray.withAlphaComponent(0.7).cgColor
        dot.layer.borderWidth = 1
        addSubview(dot)
    }
    
    override func panAction(_ pan: UIPanGestureRecognizer) {
        let location = pan.location(in: self)
        dot.center = location
        super.panAction(pan)
     
    }
    
}
