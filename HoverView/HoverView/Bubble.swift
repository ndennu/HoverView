//
//  Bubble.swift
//  HoverView
//
//  Created by nico on 06/01/2018.
//  Copyright © 2018 ndennu. All rights reserved.
//

import UIKit

class Bubble: UIViewController {
    
    var bubbleview = UIView()
    var panGesture = UIPanGestureRecognizer()
    var contentView = UIViewController()
    
    public func setupView(x: Double, y: Double, size: Double, contentView: UIViewController) {
        let bubble = UIView(frame: CGRect(x: x, y: y, width: size, height: size))
        self.bubbleview = bubble
        self.contentView = contentView
        configView()
    }
    
    private func configView() {
        self.bubbleview.translatesAutoresizingMaskIntoConstraints = false
        self.bubbleview.backgroundColor = UIColor.gray
        self.bubbleview.layer.cornerRadius = bubbleview.frame.size.width / 2
        
        self.panGesture = UIPanGestureRecognizer(target: contentView, action: #selector(draggableView(_:)))
        self.bubbleview.isUserInteractionEnabled = true
        self.bubbleview.addGestureRecognizer(panGesture)
        
    }
    
    @objc private func draggableView(_ sender:UIPanGestureRecognizer) {
        print("123")
        self.moveBubbleView(sender: sender)
    }
    
    func addGesture() {
        
    }
    
    private func moveBubbleView(sender: UIPanGestureRecognizer) {
        // User move the bubble
        contentView.view.bringSubview(toFront: bubbleview) // BRINGSUBVIEW ????
        let translation = sender.translation(in: contentView.view)
        self.bubbleview.center = CGPoint(x: self.bubbleview.center.x + translation.x, y: self.bubbleview.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: contentView.view)
//        self.viewbringSubview(toFront: bubbleview) // BRINGSUBVIEW ????
//        let translation = sender.translation(in: self.view)
//        bubbleview.center = CGPoint(x: bubbleview.center.x + translation.x, y: bubbleview.center.y + translation.y)
//        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}
