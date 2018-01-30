//
//  UIViewController+ChildViewController.swift
//  HoverViewFramework
//
//  Created by Jeyaksan RAJARATNAM on 29/01/2018.
//  Copyright © 2018 ajn. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addChildViewController(_ childController: UIViewController, in subview: UIView) {
        guard let view = childController.view else {
            return
        }
        view.frame = subview.bounds
        view.autoresizingMask = UIViewAutoresizing(rawValue: 0b111111)
        subview.addSubview(view)
        self.addChildViewController(childController)
    }
    
    func removeVisibleChildViewController(_ childController: UIViewController) {
        childController.removeFromParentViewController()
        childController.view.removeFromSuperview()
    }
}

