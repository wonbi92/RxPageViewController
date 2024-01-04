//
//  RxPageViewControllerDataSourceProxy.swift
//  RxPageViewController
//
//  Created by Wonbi on 2024/01/02.
//

#if os(iOS)

import UIKit
import RxCocoa

/// DelegateProxy for `UIPageViewControllerDataSource`.
final class RxPageViewControllerDataSourceProxy: DelegateProxy<UIPageViewController, UIPageViewControllerDataSource>, DelegateProxyType {
    weak private var _requiredMethodsDataSource: UIPageViewControllerDataSource?
    
    init(parentObject: UIPageViewController) {
        super.init(
            parentObject: parentObject,
            delegateProxy: RxPageViewControllerDataSourceProxy.self
        )
    }
    
    static func registerKnownImplementations() {
        self.register { RxPageViewControllerDataSourceProxy(parentObject: $0) }
    }
    
    static func currentDelegate(for object: UIPageViewController) -> UIPageViewControllerDataSource? {
        return object.dataSource
    }
    
    static func setCurrentDelegate(_ delegate: UIPageViewControllerDataSource?, to object: UIPageViewController) {
        return object.dataSource = delegate
    }
    
    override func setForwardToDelegate(_ delegate: DelegateProxy<UIPageViewController, UIPageViewControllerDataSource>.Delegate?, retainDelegate: Bool) {
        _requiredMethodsDataSource = delegate
        super.setForwardToDelegate(delegate, retainDelegate: retainDelegate)
    }
}

extension RxPageViewControllerDataSourceProxy: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        _requiredMethodsDataSource?.pageViewController(pageViewController, viewControllerBefore: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        _requiredMethodsDataSource?.pageViewController(pageViewController, viewControllerAfter: viewController)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        _requiredMethodsDataSource?.presentationCount?(for: pageViewController) ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        _requiredMethodsDataSource?.presentationIndex?(for: pageViewController) ?? 0
    }
}

#endif
