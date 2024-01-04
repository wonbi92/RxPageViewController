//
//  RxPageViewControllerReactiveDataSource.swift
//  RxPageViewController
//
//  Created by Wonbi on 2024/01/02.
//

#if os(iOS)

import UIKit
import RxSwift

/**
 Page view controller DataSource for Reactive.
 If you use an item of the data source as `UIViewController`, you can skip the generic declaration.
 */
public final class RxPageViewControllerReactiveDataSource<Item: UIViewController>: PageViewControllerDataSource<Item>, RxPageViewControllerDataSourceType {
    public typealias Element = [Item]
    
    private var isInitialObserve: Bool = true
    
    public func pageViewController(_ pageViewController: UIPageViewController, onNextHandler: ((UIPageViewController, Element) -> Void)?, observedEvent: RxSwift.Event<Element>) {
        Binder(self) { dataSource, element in
            dataSource.setElements(element)
            guard !dataSource.isInitialObserve else {
                dataSource.isInitialObserve = false
                return
            }
            onNextHandler?(pageViewController, element)
        }.on(observedEvent)
    }
}

#endif
