//
//  TriangleViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2021/1/12.
//  Copyright © 2021 lieon. All rights reserved.
//

import UIKit
import GLKit

class TriangleViewController: GLKViewController {
    fileprivate var context: EAGLContext?
    fileprivate lazy var middleware: TriangleMiddleware = TriangleMiddleware()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = EAGLContext(api: .openGLES3)
        guard let context = context, let view = view as? GLKView else {
            return
        }
        view.context = context
        view.drawableDepthFormat = .format24
        EAGLContext.setCurrent(context)
        middleware.setupGL()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        middleware.draw(in: CGRect(x: 0, y: 0, width: view.drawableWidth, height: view.drawableHeight))
    }
    
}
