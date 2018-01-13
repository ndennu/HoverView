//
//  Bubble.swift
//  HoverView
//
//  Created by nico on 06/01/2018.
//  Copyright © 2018 ndennu. All rights reserved.
//

import UIKit

class Bubble {
    
    let bubbleview: UIView
    var view: UIViewController?
    
    var panGesture = UIPanGestureRecognizer()
    
    public init(x: Double, y: Double, size: Double, view: UIViewController) {
        let bubbleview = UIView(frame: CGRect(x: x, y: y, width: size, height: size))
        self.bubbleview = bubbleview
        self.view = view
        configView()
    }
    
    private func configView() {
        bubbleview.translatesAutoresizingMaskIntoConstraints = false
        bubbleview.backgroundColor = UIColor.gray
        bubbleview.layer.cornerRadius = bubbleview.frame.size.width / 2
        
        panGesture = UIPanGestureRecognizer(target: self.view, action: #selector(self.draggableView(_:)))
        bubbleview.isUserInteractionEnabled = true
        bubbleview.addGestureRecognizer(panGesture)
        
    }
    
    @objc func draggableView(_ sender:UIPanGestureRecognizer) {
        print("123")
        moveBubbleView(sender: sender)
    }
    
    func addGesture() {
        
    }
    
    private func moveBubbleView(sender: UIPanGestureRecognizer) {
        // User move the bubble
        if let k = self.view {
            k.view.bringSubview(toFront: bubbleview) // BRINGSUBVIEW ????
            let translation = sender.translation(in: k.view)
            bubbleview.center = CGPoint(x: bubbleview.center.x + translation.x, y: bubbleview.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: k.view)
        }
//        self.viewbringSubview(toFront: bubbleview) // BRINGSUBVIEW ????
//        let translation = sender.translation(in: self.view)
//        bubbleview.center = CGPoint(x: bubbleview.center.x + translation.x, y: bubbleview.center.y + translation.y)
//        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}
