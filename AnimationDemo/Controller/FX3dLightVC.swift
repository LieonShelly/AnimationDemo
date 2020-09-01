//
//  FX3dLightVC.swift
//  AnimationDemo
//
//  Created by lieon on 2020/8/29.
//  Copyright © 2020 lieon. All rights reserved.
//

import Foundation

class FX3dLightVC: UIViewController {

    fileprivate lazy var moveLightPannel: FX3DLightMoveLightPanel = {
        let view = FX3DLightMoveLightPanel()
        return view
    }()
    
    fileprivate var startPoint: CGPoint = .zero
    fileprivate var endPoint: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let tapView = FX3DLightExchangeLightSourceBtn()
        view.addSubview(tapView)
        tapView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 35, height: 35))
        }
        let mW: CGFloat = 200
        let mH: CGFloat = 800
        moveLightPannel.frame = CGRect(x: (view.bounds.width - mW) * 0.5 , y: (view.bounds.height - mH) * 0.5, width: mW, height: mH)
        let pathW: CGFloat = 240
        let pathH: CGFloat = 400
        view.addSubview(moveLightPannel)
        let pathRect = CGRect(x: (moveLightPannel.bounds.width - pathW) * 0.5,
                              y: (moveLightPannel.bounds.height - pathH) * 0.5,
                              width: pathW, height: pathH)
        moveLightPannel.configSuperPath(pathRect, nosePoint: CGPoint(x: pathRect.midX, y: pathRect.midY))
   
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view) else {
            return
        }
        startPoint = point
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view) else {
            return
        }
        let deltaX = point.x - startPoint.x
        let deltaY = point.y - startPoint.y
        moveLightPannel.updateLocation(deltaX, deltaY: deltaY)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveLightPannel.moveEnd()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveLightPannel.moveEnd()
    }
    
 
}
