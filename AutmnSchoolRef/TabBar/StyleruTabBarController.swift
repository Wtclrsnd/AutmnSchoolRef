//
//  StyleruTabBarController.swift
//  AutmnSchoolRef
//
//  Created by Emil Shpeklord on 11.08.2024.
//

import UIKit

class StyleruTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .link
        tabBar.tintColor = .link
        tabBar.isTranslucent = false
        setupVCs()
    }

    private func createViewController(for viewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }

    private func setupVCs() {
        viewControllers = [
            createViewController(
                for: AnimationsViewController(),
                title: "Animations",
                image: UIImage(systemName: "play.circle.fill") ?? UIImage()),
            createViewController(
                for: ListCollectionViewController(),
                title: "List",
                image: UIImage(systemName: "table.fill") ?? UIImage())
        ]
    }
}

