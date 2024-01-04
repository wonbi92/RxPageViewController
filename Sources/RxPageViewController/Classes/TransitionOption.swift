//
//  TransitionOption.swift
//  RxPageViewController
//
//  Created by Wonbi on 2024/01/02.
//

#if os(iOS)

import UIKit

/// Option of transition for page view controller.
public enum TransitionOption {
    public typealias ViewControllerFactory = (UIPageViewController, UIViewController) -> UIViewController?
    /**
     Default transition option.
     
     The view transition only within bound view controllers.
     */
    case `default`
    /**
     Infinite transition option.
     
     The view transition by repeating bound view controllers infinitely.
     */
    case infinity
    
    /**
     Custom transition option.
     
     Customizes the behavior of the `pageViewController(_:viewControllerAfter:)` method and the `pageViewController(_:viewControllerBefore:)` method.
     
     - parameter viewControllerAfter: Define the `pageViewController(_:viewControllerAfter:)` method behavior of the `UIPageViewControllerDataSource`.
     - parameter viewControllerBefore: Define the `pageViewController(_:viewControllerBefore:)` method behavior of the `UIPageViewControllerDataSource`.
     */
    case custom(viewControllerAfter: ViewControllerFactory, viewControllerBefore: ViewControllerFactory)
}

#endif
