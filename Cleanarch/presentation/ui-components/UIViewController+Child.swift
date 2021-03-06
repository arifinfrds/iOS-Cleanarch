//
//  UIViewController+Child.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/18/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func addChildVC(asChildViewController viewController: UIViewController, to containerView: UIView) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    public func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
