//
//  RxPageViewControllerDataSourceType.swift
//  RxPageViewController
//
//  Created by Wonbi on 2024/01/02.
//

#if os(iOS)

import UIKit
import RxSwift

/// Marks data source as `UIPageViewController` reactive data source enabling it to be used with one of the `bindTo` methods.
public protocol RxPageViewControllerDataSourceType {
    
    /// Type of elements that can be bound to UIPageViewController.
    associatedtype Element
    
    /// New observable sequence event observed.
    ///
    /// - parameter pageViewController: Bound page view controller
    /// - parameter onNextHandler: handler for next Event
    /// - parameter observedEvent: Event
    func pageViewController(_ pageViewController: UIPageViewController, onNextHandler: ((UIPageViewController, Element) -> Void)?, observedEvent: RxSwift.Event<Element>)
}

#endif
