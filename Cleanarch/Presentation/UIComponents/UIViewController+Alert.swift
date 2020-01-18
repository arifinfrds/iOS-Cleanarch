//
//  UIViewController+Alert.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/18/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func showAlertController(withTitle title: String, message: String, completion: (() -> ())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Oke", style: .default) { action in
            completion?()
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
