//
//  File.swift
//  HoverView
//
//  Created by nico on 03/01/2018.
//  Copyright © 2018 ndennu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let button : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Navigation", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(touchNext), for: .touchUpInside)
        return button
    }()
    
    lazy var viewDrag: UIView = {
        let viewDrag = UIView(frame: CGRect(x: 150.0, y: 150.0, width: 100.0, height: 100.0))
        viewDrag.translatesAutoresizingMaskIntoConstraints = false
        viewDrag.backgroundColor = UIColor.green
        viewDrag.layer.cornerRadius = viewDrag.frame.size.width / 2
        return viewDrag
    }()
    
    var panGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.blue
        self.title = "Main"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBubble))
        
        view.addSubview(button)
        
        setupButton()
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        viewDrag.isUserInteractionEnabled = true
        viewDrag.addGestureRecognizer(panGesture)
        
    }
    
    // Constraints X, Y, Width, Height for button
    private func setupButton() {
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // Navigate on an other view
    @objc func touchNext() {
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    // Add only one bubble
    @objc func addBubble() {
        view.addSubview(viewDrag)
    }
    
    // a comprendre
    // Gestion du drag n drop
    @objc func draggedView(_ sender:UIPanGestureRecognizer) {
        self.view.bringSubview(toFront: viewDrag)
        let translation = sender.translation(in: self.view)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        
        
        if(sender.state == UIGestureRecognizerState.ended) {
            print("bounds: ", UIScreen.main.bounds.width / 2, "view: ", self.view.frame.size.width/2, "\n")
            print(viewDrag.layer.frame.origin.x, "--", viewDrag.layer.frame.origin.y)
//            if (viewDrag.layer.frame.origin.x >= self.view.frame.size.width/2) {
//
//            }
            // OR
            if (viewDrag.layer.frame.origin.x <= UIScreen.main.bounds.width / 2) {
                viewDrag.center = CGPoint(x: 20, y: viewDrag.center.y + translation.y) // centre at 20
            } else {
                viewDrag.layer.frame.origin.x = UIScreen.main.bounds.width - 20 // origin (border left) at 20
            }
        }
    }
}


