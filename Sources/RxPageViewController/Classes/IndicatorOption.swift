//
//  IndicatorOption.swift
//  RxPageViewController
//
//  Created by Wonbi on 2024/01/02.
//

#if os(iOS)

import UIKit

/// Option of indicator in page view controller
public enum IndicatorOption {
    public typealias IndicatorFactory = (UIPageViewController) -> Int
    
    /// Disable the indicator.
    case none
    /**
     Use the default indicator provided by Apple.
     
     The `presentationCount(for:)` method automatically returns the total number of pages.
     
     The `presentationIndex(for:)` method automatically returns the index of the current page.
     */
    case `default`
    /**
     Use the default indicator provided by Apple.
     
     Customizes the behavior of the `presentationCount(for:)` method and the `presentationIndex(for:)` method.
     
     - parameter presentationCount: Define the `presentationCount(for:)` method behavior of the `UIPageViewControllerDataSource`.
     - parameter presentationIndex: Define the `presentationIndex(for:)` method behavior of the `UIPageViewControllerDataSource`.
     */
    case custom(presentationCount: IndicatorFactory, presentationIndex: IndicatorFactory)
}

#endif
