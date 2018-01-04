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
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(touchNext), for: .touchUpInside)
        return button
    }()
    
    let middle : UIView = {
        let middle = UIView(frame: CGRect(x: 150.0, y: 150.0, width: 3.0, height: UIScreen.main.bounds.height))
        middle.backgroundColor = UIColor.white
        return middle
    }()
    
    lazy var viewDrag : UIView = {
        let viewDrag = UIView(frame: CGRect(x: 150.0, y: 150.0, width: 100.0, height: 100.0))
        viewDrag.translatesAutoresizingMaskIntoConstraints = false
        viewDrag.backgroundColor = UIColor.green
        viewDrag.layer.cornerRadius = viewDrag.frame.size.width / 2
        return viewDrag
    }()
    
    lazy var trash : UIView = {
        let trash = UIView()
        trash.backgroundColor = UIColor.yellow
        //let trash = UIView()
        trash.translatesAutoresizingMaskIntoConstraints = false
        return trash
    }()
    
    var panGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.blue
        self.title = "Main"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBubble))
        
        view.addSubview(middle)
        view.addSubview(button)
        
        setupButton()
        setupMiddle()
        
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
    
    // Constraints X, Y, Width, Height for trash view
    private func setupTrash() {
        trash.centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        trash.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.layer.frame.height/3).isActive = true
        trash.widthAnchor.constraint(equalToConstant: 50).isActive = true
        trash.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    // TODO: A DELETE JUSTE POUR COMPRENDRE
    private func setupMiddle() {
        middle.layer.frame.origin.x = (UIScreen.main.bounds.width / 2) - 1
        middle.layer.frame.origin.y = 0
    }
    
    private func setupBubble() {
        viewDrag.layer.frame.origin.x = 150
        viewDrag.layer.frame.origin.y = 150
    }
    
    // Navigate on an other view
    @objc func touchNext() {
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    // Add only one bubble
    @objc func addBubble() {
        view.addSubview(viewDrag)
        setupBubble()
    }
    
    // Add the trash view at the bottom of the screen
    private func beginDragNDrop() {
        view.addSubview(trash)
        setupTrash()
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
        if (viewDrag.layer.frame.origin.x <= UIScreen.main.bounds.width / 2) {
            print("[DEBUG] draggedView() -- Fixed on left")
            viewDrag.center = CGPoint(x: 20, y: viewDrag.center.y + translation.y) // centre at 20
        } else {
            print("[DEBUG] draggedView() -- Fixed on right")
            viewDrag.layer.frame.origin.x = UIScreen.main.bounds.width - 20 // origin (border left) at 20
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


