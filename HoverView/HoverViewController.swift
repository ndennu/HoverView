//
//  HoverViewController.swift
//  HoverViewFramework
//
//  Created by Jeyaksan RAJARATNAM on 29/01/2018.
//  Copyright © 2018 ajn. All rights reserved.
//

import UIKit

public protocol HoverViewControllerDelegate: class {
    /// TRIGGERED WHEN THE HOVERVIEWCONTROLLER HAS LOADED (Used to get the hoverview framework instance)
    func hoverViewController(_ hoverViewController: HoverViewController)
    /// TRIGGERED WHEN THE USER TAP ON THE BUBBLE
    func hoverViewController(_ hoverViewController: HoverViewController, didTouchUpInsideHoverView view: UIView)
}

public class HoverViewController: UIViewController {
    
    public weak var delegate: HoverViewControllerDelegate?
    
    private let offset:CGFloat = 5
    
    private var previousisLandScape = UIDevice.current.orientation.isLandscape
    
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
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.addSubview(self.hvContentView)
        self.addChildViewController(self.hvRootViewController, in: self.hvContentView)
        self.delegate?.hoverViewController(self)
        setPanGesture()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        self.setupContentView()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let isLandscape = UIDevice.current.orientation.isLandscape
        
        // DO NOTHING IF PREVIOUS STATE WAS LANDSCAPE
        if (previousisLandScape && isLandscape) { return }
        
        previousisLandScape = isLandscape
        
        var ratio: CGFloat
        var transformedY: CGFloat
        // TRANSFORME THE BUBBLE VIEW'S Y POSITION WITH THE RATIO
        if (size.width > size.height) {
            ratio = size.height/size.width
            transformedY = self.hvBubbleView.layer.frame.origin.y * ratio
        } else {
            ratio = size.width/size.height
            transformedY = self.hvBubbleView.layer.frame.origin.y / ratio
        }
        self.hvBubbleView.layer.frame.origin.y = transformedY
        
        if (self.hvBubbleView.center.x <= UIScreen.main.bounds.width / 2) {
            self.hvBubbleView.layer.frame.origin.x = self.offset
        } else {
            self.hvBubbleView.layer.frame.origin.x = size.width - self.hvBubbleView.layer.frame.width - self.offset
        }
        
        // FIXE THE BUBBLE POSITION WHEN IT'S OUTSIDE OF THE UIView
        let posY = self.hvBubbleView.layer.frame.origin.y + self.hvBubbleView.layer.frame.height
        if posY > size.height {
            self.hvBubbleView.layer.frame.origin.y = size.height - self.hvBubbleView.layer.frame.height - self.offset
        }
    }
    
    // FUNCTION WHO INITIALIZE THE FRAMEWORK
    public func setupWithImage(rootViewController: UIViewController, size: CGFloat, imgBubbleName: String, imgTrashName: String) {
        self.hvRootViewController = rootViewController
        self.hvBubbleView.layer.frame.size.width = size
        self.hvBubbleView.layer.frame.size.height = size
        self.hvBubbleView.layer.cornerRadius = hvBubbleView.frame.size.width / 2
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hvBubbleViewDidTapped(sender:)))
        self.hvBubbleView.addGestureRecognizer(gesture)
        
        self.setImageInbubble(img: imgBubbleName, size: size)
        self.setImageInTrash(img: imgTrashName)
    }
    
    // ADD ONE BUBBLE, ONLY ONE
    public func addBubble() {
        view.addSubview(self.hvBubbleView)
        self.setupBubble()
    }
    
    
    /////////////////////////////////////////////////////////////////////////
    //                                                                     //
    //                                                                     //
    // CONSTRAINTS      (X, Y, WIDTH, HEIGHT)                              //
    //                                                                     //
    //                                                                     //
    /////////////////////////////////////////////////////////////////////////
    private func setupTrash() {
        self.hvTrashView.centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        self.hvTrashView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.layer.frame.height/3).isActive = true
        self.hvTrashView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.hvTrashView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupContentView() {
        self.hvContentView.frame = self.view.bounds
        self.hvContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    
    /////////////////////////////////////////////////////////////////////////
    //                                                                     //
    //                                                                     //
    // SETUP PAN GESTURE AND FIRST APPARITION BUBBLEVIEW                   //
    //                                                                     //
    //                                                                     //
    /////////////////////////////////////////////////////////////////////////
    
    
    // SET LINK USER GESTURE TO BUBBLE
    private func setPanGesture() {
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        self.hvBubbleView.isUserInteractionEnabled = true
        self.hvBubbleView.addGestureRecognizer(panGesture)
    }
    
    
    // SET THE BUBBLE POSITION WHEN IT APPAIRED
    private func setupBubble() {
        self.hvBubbleView.layer.frame.origin.x = UIScreen.main.bounds.width / 2 + 1
        self.hvBubbleView.layer.frame.origin.y = 150
        self.fixedTheBubble()
    }
    
    // SET IMAGE IN THE BUBBLE VIEW
    private func setImageInbubble(img: String, size: CGFloat) {
        let imageViewBubble = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        imageViewBubble.image = UIImage(named: img)
        imageViewBubble.contentMode = UIViewContentMode.scaleAspectFit
        self.hvBubbleView.addSubview(imageViewBubble)
    }
    
    // SET IMAGE IN THE TRASH VIEW
    private func setImageInTrash(img: String) {
        let imageViewTrash = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageViewTrash.image = UIImage(named: img)
        imageViewTrash.contentMode = UIViewContentMode.scaleAspectFit
        self.hvTrashView.addSubview(imageViewTrash)
    }
    
    /////////////////////////////////////////////////////////////////////////
    //                                                                     //
    //                                                                     //
    // EVENT DRAG N DROP AND TOUCH INSIDE                                  //
    //                                                                     //
    //                                                                     //
    /////////////////////////////////////////////////////////////////////////
    
    // EVENT -> TRIGGERED WHEN THE USER TAP ON HOVERVIEW BUBBLE
    @objc private func hvBubbleViewDidTapped(sender:UITapGestureRecognizer){
        self.delegate?.hoverViewController(self, didTouchUpInsideHoverView: self.hvBubbleView)
    }
    
    // MANAGE THE BUBBLEVIEW'S MOVEMENT
    @objc private func draggedView(_ sender:UIPanGestureRecognizer) {
        
        // user touch at the beginning the bubble
        if (sender.state == UIGestureRecognizerState.began) {
            beginDragNDrop()
        }
        
        moveBubbleView(sender: sender)
        
        // User unTouch the bubble
        if(sender.state == UIGestureRecognizerState.ended) {
            if !(removeViews()) {
                fixedTheBubble()
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////
    //                                                                     //
    //                                                                     //
    // FUNCTION RELATIVE TO DRAG N DROP                                    //
    //                                                                     //
    //                                                                     //
    /////////////////////////////////////////////////////////////////////////
    
    // ADD THE TRASHVIEW AT THE BOTTOM OF THE SCREEN
    private func beginDragNDrop() {
        view.addSubview(self.hvTrashView)
        self.setupTrash()
    }
    
    // MAKE A MOVEMENT WITH THE BUBBLE VIEW (WITH THE USER'S FINGUER)
    private func moveBubbleView(sender: UIPanGestureRecognizer) {
        // User move the bubble
        self.view.bringSubview(toFront: self.hvBubbleView)
        let translation = sender.translation(in: self.view)
        self.hvBubbleView.center = CGPoint(x: self.hvBubbleView.center.x + translation.x, y: self.hvBubbleView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // REMOVE THE TRASHVIEW TO THE SCREEN
    // RETURN TRUE IF THE BUBBLEVIEW IS REMOVED
    private func removeViews() -> Bool {
        self.hvTrashView.removeFromSuperview()
        return removeBubbleView()
    }
    
    // REMOVE THE BUBBLEVIEW TO THE SCREEN
    // RETURN TRUE IF THE BUBBLEVIEW IS REMOVED
    private func removeBubbleView() -> Bool {
        let bubbleCenterX = self.hvBubbleView.center.x
        let bubbleCenterY = self.hvBubbleView.center.y
        
        let trashCenterX = self.hvTrashView.frame.origin.x
        let trashCenterY = self.hvTrashView.frame.origin.y
        
        if ((bubbleCenterX >= trashCenterX && bubbleCenterX <= trashCenterX + self.hvTrashView.frame.size.width) && (bubbleCenterY >= trashCenterY - 40 && bubbleCenterY <= trashCenterY + self.hvTrashView.frame.size.height)) {
            self.hvBubbleView.removeFromSuperview()
            return true
        }
        return false
    }
    
    
    
    // FIXED THE BUBBLEVIEW AT THE LEFT OR THE RIGHT OF THE SCREEN
    private func fixedTheBubble() {
        if (self.hvBubbleView.center.x <= UIScreen.main.bounds.width / 2) {
            self.hvBubbleView.layer.frame.origin.x = self.offset
            fixedCorner(offset: self.offset)
        } else {
            self.hvBubbleView.layer.frame.origin.x = UIScreen.main.bounds.width - self.hvBubbleView.layer.frame.width - self.offset
            fixedCorner(offset: self.offset)
        }
    }
    
    // AVOID THE BUBBLE VIEW QUIT THE SCREEN
    private func fixedCorner(offset: CGFloat) {
        let originY = self.hvBubbleView.layer.frame.origin.y
        let originX = self.hvBubbleView.layer.frame.origin.x
        let posBottom = self.hvBubbleView.layer.frame.origin.y + self.hvBubbleView.layer.frame.height
        let posRight = self.hvBubbleView.layer.frame.origin.x + self.hvBubbleView.layer.frame.width
        let screenSizeWidth = UIScreen.main.bounds.width
        let screenSizeHeight = UIScreen.main.bounds.height
        
        if (originY <= self.offset) {
            self.hvBubbleView.layer.frame.origin.y = self.offset
        }
        
        if (posBottom >= screenSizeHeight) {
            self.hvBubbleView.layer.frame.origin.y = screenSizeHeight - self.hvBubbleView.layer.frame.height - self.offset
        }
        
        if (originX <= offset) {
            self.hvBubbleView.layer.frame.origin.x = self.offset
        }
        
        if (posRight >= screenSizeWidth) {
            self.hvBubbleView.layer.frame.origin.x = screenSizeWidth - self.hvBubbleView.layer.frame.width - self.offset
        }
    }
    
    
}
