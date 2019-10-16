
//
//  FlipViewController.swift
//  AnimationDemo
//
//  Created by lieon on 2019/10/16.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit

class FlipViewController: UIViewController {
    fileprivate lazy var flipAnimator: FlipAnimator = {
        let flipAnimator = FlipAnimator()
        return flipAnimator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }

    @IBAction func push(_ sender: Any) {
        navigationController?.pushViewController(FlipSubViewController(), animated: true)
    }

}

extension FlipViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC is FlipSubViewController || toVC is FlipViewController {
            flipAnimator.operation = operation
            return flipAnimator
        }
        return nil
    }
}
