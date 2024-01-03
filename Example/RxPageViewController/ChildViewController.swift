//
//  ChildViewController.swift
//  RxPageViewController_Example
//
//  Created by Wonbi on 2024/01/03.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

final class ChildViewController: UIViewController {
    private let label: UILabel

    init(title: String) {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 30)
        self.label = label

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = getRandomColor()
        self.label.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func getRandomColor() -> UIColor {
        let randomRed = CGFloat(drand48())
        let randomGreen = CGFloat(drand48())
        let randomBlue = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

