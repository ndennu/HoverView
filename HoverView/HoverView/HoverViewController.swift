//
//  HoverViewController.swift
//  HoverView
//
//  Created by nico on 13/01/2018.
//  Copyright © 2018 ndennu. All rights reserved.
//

import UIKit

public protocol HoverViewControllerDelegate: class {
    
    func hoverViewController(_ hoverViewController: HoverViewController)
}

public class HoverViewController: UIViewController {
    
    public weak var delegate: HoverViewControllerDelegate?
    
    private var hvRootViewController = UIViewController()
    
    private let hvContentView : UIView = {
        let hvContentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        hvContentView.backgroundColor = UIColor.gray
        return hvContentView
    }()
    
    private lazy var hvBubbleView : UIView = {
        let hvBubbleView = UIView()
        hvBubbleView.translatesAutoresizingMaskIntoConstraints = false
        hvBubbleView.backgroundColor = UIColor.red
        hvBubbleView.layer.cornerRadius = hvBubbleView.frame.size.width / 2
        return hvBubbleView
    }()
    
    private lazy var hvTrashView : UIView = {
        let hvTrashView = UIView()
        hvTrashView.translatesAutoresizingMaskIntoConstraints = false
        return hvTrashView
    }()
    
    private var panGesture = UIPanGestureRecognizer()
    
    public override func viewDidLoad() {
        self.view.addSubview(self.hvContentView)
        self.addChildViewController(self.hvRootViewController, in: self.hvContentView)
        self.setupContentView()
        self.delegate?.hoverViewController(self)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        self.hvBubbleView.isUserInteractionEnabled = true
        self.hvBubbleView.addGestureRecognizer(panGesture)
    }
    
    // Constraints X, Y, Width, Height for trash view
    private func setupTrash() {
        self.hvTrashView.centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        self.hvTrashView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.layer.frame.height/3).isActive = true
        self.hvTrashView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.hvTrashView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupContentView() {
        self.hvContentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.hvContentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.hvContentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1) .isActive = true
        self.hvContentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
    }
    
    private func setupBubble() {
        self.hvBubbleView.layer.frame.origin.x = 150
        self.hvBubbleView.layer.frame.origin.y = 150
    }
    
    public func setupWithImage(rootViewController: UIViewController, size: CGFloat, imgBubbleName: String, imgTrashName: String) {
        self.hvRootViewController = rootViewController
        self.hvBubbleView.layer.frame.size.width = size
        self.hvBubbleView.layer.frame.size.height = size
        self.hvBubbleView.layer.cornerRadius = hvBubbleView.frame.size.width / 2
        let imageViewBubble = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        imageViewBubble.image = UIImage(named: imgBubbleName)
        imageViewBubble.contentMode = UIViewContentMode.scaleAspectFit
        self.hvBubbleView.addSubview(imageViewBubble)
        
        let imageViewTrash = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageViewTrash.image = UIImage(named: imgTrashName)
        imageViewTrash.contentMode = UIViewContentMode.scaleAspectFit
        self.hvTrashView.addSubview(imageViewTrash)
    }
    
    // Add the trash view at the bottom of the screen
    private func beginDragNDrop() {
        view.addSubview(self.hvTrashView)
        setupTrash()
    }
    
    // Add only one bubble
    public func addBubble() {
        view.addSubview(self.hvBubbleView)
        setupBubble()
    }
    
    // Remove trash view to screen
    // return true if the bubbleView is removed
    private func removeViews() -> Bool {
        self.hvTrashView.removeFromSuperview()
        return removeBubbleView()
    }
    
    // Remove bubbleView to screen
    // return true if the view is removed
    private func removeBubbleView() -> Bool {
        if ((self.hvBubbleView.center.x >= self.hvTrashView.center.x-40 && self.hvBubbleView.center.x <= self.hvTrashView.center.x+40) && (self.hvBubbleView.center.y >= self.hvTrashView.center.y-40 && self.hvBubbleView.center.y <= self.hvTrashView.center.y+40)) {
            print("[DEBUG] draggedView() -- viewDrag is trash")
            self.hvBubbleView.removeFromSuperview()
            return true
        }
        return false
    }
    
    // Move bubbleView on the screen (with user's finguer)
    private func moveBubbleView(sender: UIPanGestureRecognizer) {
        // User move the bubble
        self.view.bringSubview(toFront: self.hvBubbleView) // BRINGSUBVIEW ????
        let translation = sender.translation(in: self.view)
        self.hvBubbleView.center = CGPoint(x: self.hvBubbleView.center.x + translation.x, y: self.hvBubbleView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // Fixed the bubbleView at the left or right of the screen
    private func fixedTheBubble(translation: CGPoint) {
        let offset: CGFloat = 5
        if (self.hvBubbleView.center.x <= UIScreen.main.bounds.width / 2) {
            print("[DEBUG] draggedView() -- Fixed on left")
            self.hvBubbleView.layer.frame.origin.x = offset
            fixedCorner(offset: offset)
        } else {
            print("[DEBUG] draggedView() -- Fixed on right")
            self.hvBubbleView.layer.frame.origin.x = UIScreen.main.bounds.width - self.hvBubbleView.layer.frame.width - offset
            fixedCorner(offset: offset)
        }
    }
    
    // Avoid bubble to quit screen
    private func fixedCorner(offset: CGFloat) {
        let originY = self.hvBubbleView.layer.frame.origin.y
        let posBottom = self.hvBubbleView.layer.frame.origin.y + self.hvBubbleView.layer.frame.height
        let screenSize = UIScreen.main.bounds.height
        
        if (originY <= offset) {
            self.hvBubbleView.layer.frame.origin.y = offset
        }
        
        if (posBottom >= screenSize) {
            self.hvBubbleView.layer.frame.origin.y = screenSize - self.hvBubbleView.layer.frame.height - offset
        }
        
        if let heightNavBar = self.navigationController?.navigationBar.frame.size.height,
            let originYNavBar = self.navigationController?.navigationBar.frame.origin.y {
            if (originY <= heightNavBar) {
                self.hvBubbleView.layer.frame.origin.y = heightNavBar + originYNavBar + offset
            }
        }
    }
    
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
            print("[DEBUG] draggedView() -- ", self.hvBubbleView.layer.frame.origin.x, ", ", self.hvBubbleView.layer.frame.origin.y)
            if !(removeViews()) {
                fixedTheBubble(translation: translation)
            }
        }
    }
}
