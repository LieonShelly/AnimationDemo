//
//  ZoomScollVIew.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/11.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class ZoomScollVIew: UIScrollView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          debugPrint(touches.count)
      }
      
      override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           debugPrint(touches.count)
      }
      
      override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           debugPrint(touches.count)
      }

}
