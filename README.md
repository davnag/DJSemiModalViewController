# DJSemiModalViewController

DJSemiModalViewController is a semi modal presentation dialog that grows with it´s added content. DJSemiModalViewController works for iPhone and iPad. DJSemiModalViewController mimic the design of the default NFC popup dialog.

<img src="https://raw.githubusercontent.com/davnag/DJSemiModalViewController/master/Screencast_1.gif" width="320">

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

DJSemiModalViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DJSemiModalViewController'
```

## How to use it

```swift

@IBAction func buttonAction(_ sender: Any) {

    let controller = DJSemiModalViewController()
    
    controller.title = "Title"
    
    let label = UILabel()
    label.text = "An example label"
    label.textAlignment = .center
    controller.addArrangedSubview(view: label)

    controller.presentOn(presentingViewController: self, animated: true, onDismiss: { })
}

```

### Add views to content StackView

```swift

public func addArrangedSubview(view: UIView)

public func addArrangedSubview(view: UIView, height: CGFloat)

public func insertArrangedSubview(view: UIView, at index: Int)

```

### Presenting the ViewController

```swift

public func presentOn(presentingViewController: UIViewController, animated: Bool = true, onDismiss dismissHandler: ViewWillDismiss?)

```

### Settings

```swift
controller.automaticallyAdjustsContentHeight = true
  
controller.maxWidth = 420

controller.minHeight = 200

controller.titleLabel.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)

controller.closeButton.setTitle("Done", for: .normal)

```

## Author

David Jonsén

## License

DJSemiModalViewController is available under the MIT license. See the LICENSE file for more info.

## Todo

- Make it possible to turn close methods on/off; close button, tap on background, drag gesture.

## Credits

Photo by rawpixel.com on Unsplash
