//
//  HoverViewController.swift
//  HoverView
//
//  Created by nico on 13/01/2018.
//  Copyright © 2018 ndennu. All rights reserved.
//

import UIKit

class HoverViewController: UIViewController {
    var rootViewController = UIViewController()
    
    let contentView : UIView = {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        contentView.backgroundColor = UIColor.gray
        return contentView
    }()
    
    lazy var viewDrag : UIView = {
        let viewDrag = UIView(frame: CGRect(x: 150.0, y: 150.0, width: 100.0, height: 100.0))
        viewDrag.translatesAutoresizingMaskIntoConstraints = false
        viewDrag.backgroundColor = UIColor.red
        viewDrag.layer.cornerRadius = viewDrag.frame.size.width / 2
        return viewDrag
    }()
    
    lazy var trash : UIView = {
        let trash = UIView()
        trash.backgroundColor = UIColor.yellow
        trash.translatesAutoresizingMaskIntoConstraints = false
        return trash
    }()
    
    var panGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        self.view.addSubview(contentView)
        self.addChildViewController(self.rootViewController, in: self.contentView)
        self.view.addSubview(self.viewDrag)
        self.setupContentView()
        self.setupBubble()
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        viewDrag.isUserInteractionEnabled = true
        viewDrag.addGestureRecognizer(panGesture)
    }
    
    // Constraints X, Y, Width, Height for trash view
    private func setupTrash() {
        trash.centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        trash.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.layer.frame.height/3).isActive = true
        trash.widthAnchor.constraint(equalToConstant: 50).isActive = true
        trash.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupContentView() {
        self.contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1) .isActive = true
        self.contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
    }
    
    private func setupBubble() {
        viewDrag.layer.frame.origin.x = 150
        viewDrag.layer.frame.origin.y = 150
    }
    
    // Add the trash view at the bottom of the screen
    private func beginDragNDrop() {
        view.addSubview(trash)
        setupTrash()
    }
    
    // Add only one bubble
    @objc public func addBubble() {
        view.addSubview(viewDrag)
        setupBubble()
    }
    
    // Remove trash view to screen
    // return true if the bubbleView is removed
    private func removeViews() -> Bool {
        trash.removeFromSuperview()
        return removeBubbleView()
    }
    
    // Remove bubbleView to screen
    // return true if the view is removed
    private func removeBubbleView() -> Bool {
        if ((viewDrag.center.x >= trash.center.x-40 && viewDrag.center.x <= trash.center.x+40) && (viewDrag.center.y >= trash.center.y-40 && viewDrag.center.y <= trash.center.y+40)) {
            print("[DEBUG] draggedView() -- viewDrag is trash")
            viewDrag.removeFromSuperview()
            return true
        }
        return false
    }
    
    // Move bubbleView on the screen (with user's finguer)
    private func moveBubbleView(sender: UIPanGestureRecognizer) {
        // User move the bubble
        self.view.bringSubview(toFront: viewDrag) // BRINGSUBVIEW ????
        let translation = sender.translation(in: self.view)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // Fixed the bubbleView at the left or right of the screen
    private func fixedTheBubble(translation: CGPoint) {
        
        //        if (viewDrag.layer.frame.origin.x >= self.view.frame.size.width/2) {
        //
        //        }
        // OR
        
        let offset: CGFloat = 5
        if (viewDrag.center.x <= UIScreen.main.bounds.width / 2) {
            print("[DEBUG] draggedView() -- Fixed on left")
            viewDrag.layer.frame.origin.x = offset
            fixedCorner(offset: offset)
        } else {
            print("[DEBUG] draggedView() -- Fixed on right")
            viewDrag.layer.frame.origin.x = UIScreen.main.bounds.width - viewDrag.layer.frame.width - offset
            fixedCorner(offset: offset)
        }
    }
    
    // Avoid bubble to quit screen
    private func fixedCorner(offset: CGFloat) {
        let originY = viewDrag.layer.frame.origin.y
        let posBottom = viewDrag.layer.frame.origin.y + viewDrag.layer.frame.height
        let screenSize = UIScreen.main.bounds.height
        
        if (originY <= offset) {
            viewDrag.layer.frame.origin.y = offset
        }
        
        if (posBottom >= screenSize) {
            viewDrag.layer.frame.origin.y = screenSize - viewDrag.layer.frame.height - offset
        }
        
        if let heightNavBar = self.navigationController?.navigationBar.frame.size.height,
            let originYNavBar = self.navigationController?.navigationBar.frame.origin.y {
            if (originY <= heightNavBar) {
                viewDrag.layer.frame.origin.y = heightNavBar + originYNavBar + offset
            }
        }
    }
    
    // a comprendre
    // Gestion du drag n drop
    @objc func draggedView(_ sender:UIPanGestureRecognizer) {
        
        // user touch at the beginning the bubble
        if (sender.state == UIGestureRecognizerState.began) {
            beginDragNDrop()
        }
        
        moveBubbleView(sender: sender)
        let translation = sender.translation(in: self.view) // PAS FOU MAIS BON
        
        // User unTouch the bubble
        if(sender.state == UIGestureRecognizerState.ended) {
            print("[DEBUG] draggedView() -- bounds: ", UIScreen.main.bounds.width / 2, "view: ", self.view.frame.size.width/2)
            print("[DEBUG] draggedView() -- ", viewDrag.layer.frame.origin.x, ", ", viewDrag.layer.frame.origin.y)
            if !(removeViews()) {
                fixedTheBubble(translation: translation)
            }
        }
    }
}
