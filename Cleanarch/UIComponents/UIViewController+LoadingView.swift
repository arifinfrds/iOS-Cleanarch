//
//  UIViewController+LoadingView.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/27/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import UIKit

//
//extension UIViewController {
//    
//    func showLoadingView() {
//        let viewController = LoadingViewController()
//        addChildVC(asChildViewController: viewController, to: view)
//    }
//    func dismissLoadingView() {
//        view.removeFromSuperview()
//    }
//}
//
extension UIViewController {
    
    func addChildVC(asChildViewController viewController: UIViewController, to containerView: UIView) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    func remove() {
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
