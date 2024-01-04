//
//  RxPageViewControllerDelegateProxy.swift
//  RxPageViewController
//
//  Created by Wonbi on 2024/01/02.
//

#if os(iOS)

import UIKit
import RxCocoa

extension UIPageViewController: HasDelegate { }

/// DelegateProxy for `UIPageViewControllerDelegate`.
final class RxPageViewControllerDelegateProxy: DelegateProxy<UIPageViewController, UIPageViewControllerDelegate>,
                                               DelegateProxyType,
                                               UIPageViewControllerDelegate {
    
    let spineLocationFor: BehaviorRelay<UIPageViewController.SpineLocation>
    let supportedInterfaceOrientations = BehaviorRelay<UIInterfaceOrientationMask>(value: .all)
    let preferredInterfaceOrientationForPresentation = BehaviorRelay<UIInterfaceOrientation>(value: .unknown)

    init(parentObject: UIPageViewController) {
        self.spineLocationFor = BehaviorRelay<UIPageViewController.SpineLocation>(value: parentObject.spineLocation)
        
        super.init(
            parentObject: parentObject,
            delegateProxy: RxPageViewControllerDelegateProxy.self
        )
    }

    static func registerKnownImplementations() {
        self.register { RxPageViewControllerDelegateProxy(parentObject: $0) }
    }

    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        spineLocationFor.value
    }

    func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
        supportedInterfaceOrientations.value
    }

    func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
        preferredInterfaceOrientationForPresentation.value
    }
}

#endif
