# HoverView Framework
New revolutionnary bubble component

## Prerequisites

- XCode 9 and Swift 4
- CocoaPod
- iOS 11 project

## Installation

1. Add this line to your `Podfile`
```
pod 'HoverViewFramework', '~> 1.0'
```
2. Run `pod install` to install `HoverViewFramework` to your project
3. Have fun !

## Usage

First, you must import the framework with this line :
```swift
import HoverViewFramework
```

Then, you can use HoverViewController like this exemple of usage in `AppDelegate.swift` file.
```swift
let window = UIWindow(frame: UIScreen.main.bounds)
let mainViewController = ViewController()
let rootViewController = UINavigationController(rootViewController: mainViewController)
let hoverViewController = HoverViewController()
hoverViewController.setupWithImage(rootViewController: rootViewController, size: 50, imgBubbleName: "bubbleImage.png", imgTrashName: "cross.png")
hoverViewController.delegate = mainViewController
window.rootViewController = hoverViewController
window.makeKeyAndVisible()
self.window = window
```

Then to add the bubble you need to add these line of code in your view controller 

```swift 
class ViewController: UIViewController {
    ...
    var hoverViewController: HoverViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBubble))
    }
    ...
    // Add only one bubble
    @objc func addBubble() {
        if let hvc = hoverViewController {
            hvc.addBubble()
        }
        //view.addSubview(viewDrag)
        //setupBubble()
    }
    ...
}
// Delegate to get the HoverViewController
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

## Version History

- v1.0.5

```
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