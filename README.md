# HoverView Framework
[![CocoaPods](https://img.shields.io/cocoapods/p/HoverView.svg)](https://github.com/ndennu/HoverView) [![Build Status](https://travis-ci.org/ndennu/HoverView.svg?branch=master)](https://travis-ci.org/ndennu/HoverView) [![pod version](https://cocoapod-badges.herokuapp.com/v/HoverViewFramework/badge.png)](https://cocoapod-badges.herokuapp.com/v/HoverViewFramework/badge.png)  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/ndennu/hoverview/tree/master)](http://clayallsopp.github.io/readme-score?url=https://github.com/ndennu/hoverview/tree/master) [![Coverage Status](https://coveralls.io/repos/github/ndennu/HoverView/badge.svg?branch=master)](https://coveralls.io/github/ndennu/HoverView?branch=master)

New revolutionnary bubble component

## Prerequisites

- XCode 9 and Swift 4
- CocoaPod
- iOS 11 project

## HoverViewFramework preview

![alt-text](https://raw.githubusercontent.com/jeyak/HoverViewExemple/master/readme_assets/exemple.gif)

## Installation

1. Add this line to your `Podfile`
```
pod 'HoverViewFramework', '~> 1.2'
```
2. Run `pod install` to install `HoverViewFramework` to your project
3. Have fun !

## Usage

You can found an exemple [here](https://github.com/jeyak/HoverViewExemple) on github

First, you must import the framework with this line :
```swift
import HoverViewFramework
```

Then, you can use HoverViewController like this exemple of usage.
```swift
let mainViewController = ViewController()
let rootViewController = UINavigationController(rootViewController: mainViewController)
let hoverViewController = HoverViewController()
hoverViewController.setupWithImage(rootViewController: rootViewController, size: 50, imgBubbleName: "bubbleImage.png", imgTrashName: "cross.png")
hoverViewController.delegate = mainViewController
```

To add the bubble you need to call hvc.addBubble() in your view controller 

```swift 
class ViewController: UIViewController {
    // ... some code
    // Add only one bubble
    func addBubble() {
        // We need to call hvc.addBubble() to display a bubble
        // You can call it in button action code
        if let hvc = hoverViewController {
            hvc.addBubble()
        }
    }
    // ... some code
}
// Delegate to get the HoverViewController and other usefull event
extension ViewController: HoverViewControllerDelegate {
    public func hoverViewController(_ hoverViewController: HoverViewController) {
        self.hoverViewController = hoverViewController
    }
}
```

## HoverViewController's available methods

Method name | Parameters | Return type |
--- | --- | --- |
init | none | HoverViewController
setupWithImage | bubbleImage name and trash image name | void |
addBubble | none | void |

## HoverViewControllerDelegate's available methods

Method name | Parameters | Return type |
--- | --- | --- |
hoverViewController | HoverViewController | void
hoverViewController / didTouchUpInsideHoverView | HoverViewController and UIView | void

#### Delegate implementation

```swift
extension ViewController: HoverViewControllerDelegate {
    /// TRIGGERED WHEN THE HOVERVIEWCONTROLLER HAS LOADED (Used to get the hoverview framework instance)
    func hoverViewController(_ hoverViewController: HoverViewController) {
        // ... some code
    }
    /// TRIGGERED WHEN THE USER TAP ON THE BUBBLE
    func hoverViewController(_ hoverViewController: HoverViewController, didTouchUpInsideHoverView view: UIView) {
        // ... some code
    }
}

```

## Version History

- v1.2.0

```
- Fixed landcape mode handling for HoverViewController
- Added automatic positioning for the BubbleView
```

- v1.1.5

```
- Added new tap event for BubbleView in delegate
- Fixed README.md
```

- v1.0.3

```
- Initial working release
```

## Credits

- Ahmed HACHEMI (Developper)
- Jeyaksan RAJARATNAM (Developper)
- Nicolas DENNU (Developper)

## Licence

```
MIT License

Copyright (c) 2018 ajn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```