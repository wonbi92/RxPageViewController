//
//  PageViewControllerDataSource.swift
//  RxPageViewController
//
//  Created by Wonbi on 2024/01/02.
//

#if os(iOS)

import UIKit

public class PageViewControllerDataSource<Item: UIViewController>: NSObject, UIPageViewControllerDataSource {
    var elements: [Item] = []
    
    private let transitionOption: TransitionOption
    private let indicatorOption: IndicatorOption
    private var onNext: ((UIPageViewController, [Item]) -> Void)?
    
    public init(
        transitionOption: TransitionOption,
        indicatorOption: IndicatorOption
    ) {
        self.transitionOption = transitionOption
        self.indicatorOption = indicatorOption
    }
    
    func setElements(_ elements: [Item]) {
        self.elements = elements
    }
    
    func setOnNext(_ closure: @escaping (UIPageViewController, [Item]) -> Void) {
        self.onNext = closure
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let elements = elements.map { $0 as UIViewController }
        
        switch transitionOption {
        case .default:
            guard let index = elements.firstIndex(of: viewController), index + 1 < elements.count else { return nil }
            return elements[index + 1]
            
        case .infinitiy:
            guard let index = elements.firstIndex(of: viewController) else { return nil }
            return (index + 1 < elements.count) ? elements[index + 1] : elements.first
            
        case let .custom(viewControllerAfter, _):
            return viewControllerAfter(pageViewController, viewController)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let elements = elements.map { $0 as UIViewController }
        
        switch transitionOption {
        case .default:
            guard let index = elements.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
            return elements[index - 1]
            
        case .infinitiy:
            guard let index = elements.firstIndex(of: viewController) else { return nil }
            return (index - 1 >= 0) ? elements[index - 1] : elements.last
            
        case let .custom(_, viewControllerBefore):
            return viewControllerBefore(pageViewController, viewController)
        }
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        switch indicatorOption {
        case .none:
            return 0
        case .default:
            return elements.count
        case let .custom(presentationCount, _):
            return presentationCount(pageViewController)
        }
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        let elements = elements.map { $0 as UIViewController }
        
        switch indicatorOption {
        case .none:
            return 0
        case .default:
            guard let viewController = pageViewController.viewControllers?.first,
                  let index = elements.firstIndex(of: viewController)
            else {
                return 0
            }
            
            return index
        case let .custom(_, presentationIndex):
            return presentationIndex(pageViewController)
        }
    }
}

#endif
