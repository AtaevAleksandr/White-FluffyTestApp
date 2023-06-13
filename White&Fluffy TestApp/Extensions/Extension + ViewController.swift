//
//  Extension + ViewController.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 11.06.2023.
//

import Foundation
import UIKit

extension SceneDelegate {

    private func createFirstController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: SearchPhotosViewController())
        navigationController.tabBarItem = UITabBarItem(title: "Random photos", image: UIImage(systemName: "photo.on.rectangle.angled"), tag: 0)
        return navigationController
    }

    private func createSecondController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: ListOfFavoritePhotosViewController())
        navigationController.tabBarItem = UITabBarItem(title: "Favorite photos", image: UIImage(systemName: "heart.rectangle"), tag: 1)
        return navigationController
    }

    func createTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [createFirstController(), createSecondController()]
        tabBar.tabBar.backgroundColor = .white
        tabBar.tabBar.tintColor = .systemPink
        tabBar.navigationItem.hidesBackButton = true
        return tabBar
    }
}
