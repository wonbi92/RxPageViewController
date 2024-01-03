//
//  ViewController.swift
//  RxPageViewController
//
//  Created by wonbi92 on 01/03/2024.
//  Copyright (c) 2024 wonbi92. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxPageViewController

final class ViewController: UIViewController {
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("addChild", for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return pageViewController
    }()

    private let viewControllerRelay = BehaviorRelay(value: [ChildViewController(title: "1"),
                                                            ChildViewController(title: "2"),
                                                            ChildViewController(title: "3"),
                                                            ChildViewController(title: "4")])
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureButtonAction()
        configurePageViewController()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .systemGray
        
        self.view.addSubview(addButton)
        self.view.addSubview(self.pageViewController.view)
        
        NSLayoutConstraint.activate([
            self.addButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.addButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.addButton.heightAnchor.constraint(equalToConstant: 40),
            self.addButton.widthAnchor.constraint(equalToConstant: 100),
            self.pageViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            self.pageViewController.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.pageViewController.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.pageViewController.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureButtonAction() {
        addButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let data = owner.viewControllerRelay.value
                
                owner.viewControllerRelay.accept(data + [ChildViewController(title: "\(data.count + 1)")])
            }
            .disposed(by: disposeBag)
    }
    
    private func configurePageViewController() {
        // Initial setup for page view controller
        viewControllerRelay
            .subscribe(with: self) { owner, viewControllers in
                owner.pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true)
            }
            .dispose()
        
        // Setup DataSource
        let dataSource = RxPageViewControllerReactiveDataSource<ChildViewController>(transitionOption: .default, indicatorOption: .default)
        
        // bind DataSource to Observable
        viewControllerRelay
            .bind(to: pageViewController.rx.items(dataSource: dataSource)) { pageViewController, viewcontrollers in
                guard let last = viewcontrollers.last else { return }
                
                pageViewController.setViewControllers([last], direction: .forward, animated: true)
            }
            .disposed(by: disposeBag)
        
        // Delegate
        pageViewController.rx.didFinishAnimating
            .subscribe(onNext: { parameters in
                // do something..
            })
            .disposed(by: disposeBag)
    }
}

