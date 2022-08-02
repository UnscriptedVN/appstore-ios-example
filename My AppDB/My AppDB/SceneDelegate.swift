//
//  SceneDelegate.swift
//  My AppDB
//
//  Created by Marquis Kurt on 8/2/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        let mainVC = ViewController()
        let browseNC = UINavigationController(rootViewController: mainVC)
        browseNC.navigationBar.prefersLargeTitles = true

        let cartVC = CartViewController()
        let cartNC = UINavigationController(rootViewController: cartVC)
        cartNC.navigationBar.prefersLargeTitles = true

        let tabs = UITabBarController()
        browseNC.tabBarItem = .init(title: "Browse", image: UIImage(systemName: "star"), tag: 0)
        cartNC.tabBarItem = .init(title: "Cart", image: UIImage(systemName: "cart"), tag: 1)
        tabs.setViewControllers([browseNC, cartNC], animated: true)

        self.window?.rootViewController = tabs
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

