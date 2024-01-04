# RxPageViewController

[![CI Status](https://img.shields.io/travis/wonbi92/RxPageViewController.svg?style=flat)](https://travis-ci.org/wonbi92/RxPageViewController)
[![Version](https://img.shields.io/cocoapods/v/RxPageViewController.svg?style=flat)](https://cocoapods.org/pods/RxPageViewController)
[![License](https://img.shields.io/cocoapods/l/RxPageViewController.svg?style=flat)](https://cocoapods.org/pods/RxPageViewController)
[![Platform](https://img.shields.io/cocoapods/p/RxPageViewController.svg?style=flat)](https://cocoapods.org/pods/RxPageViewController)

## Demo

To run the demo project, clone the repo, in the **Example** folder open `RxPageViewController.xcworkspace`.

You *might* need to run `pod install` from the Example directory first.

## Installation 📲

RxPageViewController is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your `Podfile`:

```ruby
pod 'RxPageViewController'
```

Install the pods by running `pod install`.

```ruby
$ pod install
```

Add `import RxPageViewController` in the .swift files where you want to use it

## Usage 

**RxPageViewController** facilitates easy usage of `UIPageViewController`'s Delegate and DataSource in the Rx environment.<br>
Additionally, it provides `TransitionOption` and `IndicatorOption` to enable easy implementation of simple behaviors.


First, define the `UIPageViewController` and specify the list of view controllers that will be displayed through it.<br>
Then, initiate the initial setup using the `setViewControllers(_:direction:animated:completion:)` method.<br>
Until this method is called, the page view controllers are not actually displayed on the screen.

```swift
let pageViewController: UIPageViewController = {
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    return pageViewController
}()

let viewControllerRelay = BehaviorRelay(value: [ChildViewController(title: "1"),
                                                ChildViewController(title: "2"),
                                                ChildViewController(title: "3"),
                                                ChildViewController(title: "4")])
                                                
viewControllerRelay
    .subscribe(with: self) { owner, viewControllers in
        owner.pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true)
    }
    .dispose()
```

Next, define the `RxPageViewControllerReactiveDataSource`. 

```swift
let dataSource = RxPageViewControllerReactiveDataSource<ChildViewController>(transitionOption: .default, indicatorOption: .none)
```

When defining the `RxPageViewControllerReactiveDataSource`, you can specify `TransitionOption` and `IndicatorOption`. <br>
These options allow you to easily define the default behavior of the data source. <br>
Please refer to the [DataSource Option](#datasource-option) section for detailed explanations.

Finally, bind the list of view controllers to the `pageViewController`. <br>
During the binding, you can define the actions to be taken when the Observable sequence emits the next event.

```swift
viewControllerRelay
    .bind(to: pageViewController.rx.items(dataSource: dataSource)) { pageViewController, viewcontrollers in
        guard let last = viewcontrollers.last else { return }
        
        pageViewController.setViewControllers([last], direction: .forward, animated: true)
    }
    .disposed(by: disposeBag)
```

The above example defines the action to navigate to the last page when the next event is emitted.

![nextAction](https://i.imgur.com/5Cst8IF.gif)

If such behavior is not needed, it can be omitted.

```swift
viewControllerRelay
    .bind(to: pageViewController.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
```

That's it! For the complete code and more details, please refer to the **Example** project.

## DataSource Option 

These options help define the data source conveniently. 

### TransitionOption

`TransitionOption` provides three options: default, infinity, and custom. <br>
The `default` and `infinity` options offer basic paging behavior.

|default|infinity|
|:---:|:---:|
|![default](https://i.imgur.com/Nj7ckGN.gif)|![infinity](https://i.imgur.com/dQ11VPC.gif)|

Through the `custom` option, you can define the paging behavior. 
Define the methods of the existing `UIPageViewControllerDataSource` directly.

```swift
let dataSource = RxPageViewControllerReactiveDataSource<ChildViewController>(
    transitionOption: .custom(
        viewControllerAfter: { pageViewController, viewController in
            // do something and return ViewController or nil
        },
        viewControllerBefore: { pageViewController, viewController in
            // do something and return ViewController or nil
        }
    ), indicatorOption: .none)
```

### IndicatorOption

`IndicatorOption` provides three options. <br>
The `none` option deactivates the indicator. <br>
The `default` option uses the indicator provided by Apple, which displays the current page among all the pages.

|none|default|
|:---:|:---:|
|![default](https://i.imgur.com/Nj7ckGN.gif)|![indicator](https://i.imgur.com/Ak2milf.gif)|

Similarly, `IndicatorOption` allows you to define the behavior of the indicator directly through the `custom` option.<br>
Define the methods of the existing `UIPageViewControllerDataSource` directly for custom indicator behavior.

```swift
let dataSource = RxPageViewControllerReactiveDataSource<ChildViewController>(
    transitionOption: .default,
    ndicatorOption: .custom(
        presentationCount: { pageViewController in
            // do something and return Int
        },
        presentationIndex: { pageViewController in
            // do something and return Int
        }
    )
)
```

If you want to implement all behaviors directly, you can write it as follows:

```swift
let dataSource = RxPageViewControllerReactiveDataSource<ChildViewController>(
    transitionOption: .custom(
        viewControllerAfter: { pageViewController, viewController in
            // do something and return ViewController or nil
        },
        viewControllerBefore: { pageViewController, viewController in
            // do something and return ViewController or nil
        }
    ), indicatorOption: .custom(
        presentationCount: { pageViewController in
            // do something and return Int
        },
        presentationIndex: { pageViewController in
            // do something and return Int
        }
    )
)
```

## Requirements

This library depends on both **RxSwift** and **RxCocoa**.

## Author ✏️

wonbi92, bin9239@gmail.com

## License 📝

RxPageViewController is available under the MIT license. See the LICENSE file for more info.
