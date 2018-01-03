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
        return button
    }()
    
    let viewDrag: UIView = {
        let viewDrag = UIView(frame: CGRect(x: 150.0, y: 150.0, width: 100.0, height: 44.0))
        viewDrag.translatesAutoresizingMaskIntoConstraints = false
        viewDrag.backgroundColor = UIColor.green
        
        return viewDrag
    }()
    
    var panGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.blue
        
        view.addSubview(button)
        view.addSubview(viewDrag)
        
        setupButton()
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        viewDrag.isUserInteractionEnabled = true
        viewDrag.addGestureRecognizer(panGesture)
        
    }
    
    private func setupButton() {
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // a comprendre
    // Gestion du drag n drop
    @objc func draggedView(_ sender:UIPanGestureRecognizer) {
        self.view.bringSubview(toFront: viewDrag)
        let translation = sender.translation(in: self.view)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}


