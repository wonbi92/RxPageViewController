//
//  UIPageViewController+Rx.swift
//  Pods-RxPageViewController_Example
//
//  Created by Wonbi on 2024/01/02.
//

#if os(iOS)

import UIKit
import RxSwift
import RxCocoa

// Delegate
public extension Reactive where Base: UIPageViewController {
    
    /// Parametars for `delegate` message `pageViewController(_:willTransitionTo:)`
    typealias WillTransitionToEvent = (pagaViewController: UIPageViewController,
                                       willTransitionTo: [UIViewController])
    
     /// Parametars for `delegate` message `pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:)`
    typealias DidFinishAnimatingEvent = (pagaViewController: UIPageViewController,
                                         didFinishAnimating: Bool,
                                         previousViewControllers: [UIViewController],
                                         transitionCompleted: Bool)
    
    internal var delegate: RxPageViewControllerDelegateProxy {
        return RxPageViewControllerDelegateProxy.proxy(for: base)
    }
    
    /**
    Reactive wrapper for `delegate` message `pageViewController(_:willTransitionTo:)`.
     
    `WillTransitionToEvent` has the following Parameters
     
     - parameter pageViewController: The page view controller.
     - parameter willTransitionTo: The view controllers that are being transitioned to.
    */
    var willTransitionTo: Observable<WillTransitionToEvent> {
        delegate.methodInvoked(#selector(UIPageViewControllerDelegate.pageViewController(_:willTransitionTo:)))
            .compactMap {
                guard let pagaViewController = $0[0] as? UIPageViewController,
                      let willTransitionTo = $0[1] as? [UIViewController]
                else {
                    return nil
                }
                
                return (pagaViewController, willTransitionTo)
            }
    }

    /**
     Reactive wrapper for `delegate` message `pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:)`.
     
     `DidFinishAnimatingEvent` has the following Parameters
     
     - parameter pagaViewController: The page view controller.
     - parameter didFinishAnimating: [true](https://developer.apple.com/documentation/swift/true) if the animation finished; otherwise, [false](https://developer.apple.com/documentation/swift/false).
     - parameter previousViewControllers: The view controllers prior to the transition.
     - parameter transitionCompleted: [true](https://developer.apple.com/documentation/swift/true) if the user completed the page-turn gesture; otherwise, [false](https://developer.apple.com/documentation/swift/false).     
     */
    var didFinishAnimating: Observable<DidFinishAnimatingEvent> {
        delegate.methodInvoked(#selector(UIPageViewControllerDelegate.pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:)))
            .compactMap {
                guard let pagaViewController = $0[0] as? UIPageViewController,
                      let didFinishAnimating = $0[1] as? Bool,
                      let previousViewControllers = $0[2] as? [UIViewController],
                      let transitionCompleted = $0[3] as? Bool
                else {
                    return nil
                }
                
                return (pagaViewController, didFinishAnimating, previousViewControllers, transitionCompleted)
            }
    }

    /// Binder for `pageViewController(_:spineLocationFor:)`
    var spineLocationFor: Binder<UIPageViewController.SpineLocation> {
        Binder(delegate) { del, value in
            del.spineLocationFor.accept(value)
        }
    }

    /// Binder for `pageViewControllerSupportedInterfaceOrientations(_:)`
    var supportedInterfaceOrientations: Binder<UIInterfaceOrientationMask> {
        Binder(delegate) { del, value in
            del.supportedInterfaceOrientations.accept(value)
        }
    }

    /// Binder for `pageViewControllerPreferredInterfaceOrientationForPresentation(_:)`
    var preferredInterfaceOrientationForPresentation: Binder<UIInterfaceOrientation> {
        Binder(delegate) { del, value in
            del.preferredInterfaceOrientationForPresentation.accept(value)
        }
    }
    
    // DataSoure
    
    /**
    Binds elements to page view Controller with next event handler.
     
    - parameter dataSource: Data source used to transform elements.
    - parameter source: Observable sequence of items.
    - parameter onNextHandler: Handler for next event.
    - returns: Disposable object that can be used to unbind.
     
     When additional behavior needs to be defined upon binding data to the page view controller, use this method.
     
    ```
     let items = Observable.just([
        UIViewController(),
        UIViewController(),
        UIViewController()
     ])
     
     let dataSource = RxPageViewControllerReactiveDataSource(transitionOption: .default, indicatorOption: .none)
     
     items
        .bind(to: pageViewController.rx.items(dataSource: dataSource)) { (pageViewController, viewControllers) in
            guard let last = viewcontrollers.last else { return }
     
            pageViewController.setViewControllers([last], direction: .forward, animated: true)
        }
        .disposed(by: disposeBag)
     ```
     */
    func items<DataSource: RxPageViewControllerDataSourceType & UIPageViewControllerDataSource,
               Source: ObservableType>
    (dataSource: DataSource)
    -> (_ source: Source)
    -> (_ onNextHandler: @escaping (UIPageViewController, DataSource.Element) -> Void)
    -> Disposable
    where Source.Element == DataSource.Element {
        return { source in
            return { onNextHandler in
                return source.enumerated().subscribeProxyDataSource(
                    ofObject: self.base,
                    dataSource: dataSource,
                    retainDataSource: true)
                { [weak pageViewController = self.base] (_: RxPageViewControllerDataSourceProxy, isInitialObserve, event) in
                    guard let pageViewController, let elements = event.element?.element else { return }
                    
                    dataSource.pageViewController(pageViewController, observedEvent: event.map { $1 })
                    
                    if !isInitialObserve {
                        onNextHandler(pageViewController, elements)
                    }
                }
            }
        }
    }
    
    /**
    Binds elements to page view Controller.
    
    - parameter dataSource: Data source used to transform elements.
    - parameter source: Observable sequence of items.
    - returns: Disposable object that can be used to unbind.
     
     If there is no need to define additional actions upon the occurrence of the following event, use this method.
     ```
      let items = Observable.just([
         UIViewController(),
         UIViewController(),
         UIViewController()
      ])
      
      let dataSource = RxPageViewControllerReactiveDataSource(transitionOption: .default, indicatorOption: .none)
      
      items
         .bind(to: pageViewController.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
      ```
    */
    func items<DataSource: RxPageViewControllerDataSourceType & UIPageViewControllerDataSource,
               Source: ObservableType>
    (dataSource: DataSource)
    -> (_ source: Source)
    -> Disposable
    where DataSource.Element == Source.Element {
        return { source in
            return source.enumerated().subscribeProxyDataSource(
                ofObject: self.base,
                dataSource: dataSource as UIPageViewControllerDataSource,
                retainDataSource: true
            ) { [weak pageViewController = self.base] (_: RxPageViewControllerDataSourceProxy, _, event) in
                guard let pageViewController else { return }
                
                dataSource.pageViewController(pageViewController, observedEvent: event.map { $1 })
            }
        }
    }
}

fileprivate extension ObservableType {
    func bindingError(_ error: Swift.Error) {
        let error = "Binding error: \(error)"
    #if DEBUG
        fatalError(error)
    #else
        print(error)
    #endif
    }
    
    /// subscribe proxy for RxPageViewControllerReactiveDataSource
    func subscribeProxyDataSource<DelegateProxy: DelegateProxyType>(
        ofObject object: DelegateProxy.ParentObject,
        dataSource: DelegateProxy.Delegate,
        retainDataSource: Bool,
        binding: @escaping (DelegateProxy, Bool, Event<Element>) -> Void
    ) -> Disposable where DelegateProxy.ParentObject: UIPageViewController, DelegateProxy.Delegate: AnyObject {
        let proxy = DelegateProxy.proxy(for: object)
        let unregisterDelegate = DelegateProxy.installForwardDelegate(dataSource, retainDelegate: retainDataSource, onProxyForObject: object)

        let subscription = self.asObservable()
            .observe(on:MainScheduler())
            .catch { error in
                bindingError(error)
                return Observable.empty()
            }
            .concat(Observable.never())
            .take(until: object.rx.deallocated)
            .subscribe { [weak object] (event: Event<Element>) in
                guard let element = event.element as? (Int, [UIViewController]) else {
                    if case let .error(error) = event {
                        bindingError(error)
                    }
                    unregisterDelegate.dispose()
                    return
                }
                
                if let object = object {
                    assert(proxy === DelegateProxy.currentDelegate(for: object), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(String(describing: DelegateProxy.currentDelegate(for: object)))")
                }
                let index = element.0
                binding(proxy, index == 0, event)
                
                switch event {
                case .error(let error):
                    bindingError(error)
                    unregisterDelegate.dispose()
                case .completed:
                    unregisterDelegate.dispose()
                default:
                    break
                }
            }
            
        return Disposables.create {
            subscription.dispose()
            unregisterDelegate.dispose()
        }
    }
}

#endif
