//
//  HoverViewControllerTest.swift
//  HoverViewTests
//
//  Created by Jeyaksan RAJARATNAM on 29/01/2018.
//  Copyright © 2018 ajn. All rights reserved.
//

import XCTest
@testable import HoverView

class HoverViewControllerTest: XCTestCase {
    
    var viewController: HoverViewController!
    
    override func setUp() {
        self.viewController = HoverViewController()
    }
    
    func testInitHoverViewController() {
        XCTAssertNotNil(HoverViewController())
    }
    
    func testHoverViewContollerSetupWithImage() {
        self.viewController.setupWithImage(rootViewController: UIViewController(), size: 50, imgBubbleName: "", imgTrashName: "")
        XCTAssertNoThrow("No exception")
    }
    
    func testAddBubble() {
        self.viewController.addBubble()
        XCTAssertNoThrow("No exception")
    }
}
