//
//  SceneDelegate.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 21.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        let mainVC = MainViewController()
        let navVC = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {    }

    func sceneDidBecomeActive(_ scene: UIScene) {    }

    func sceneWillResignActive(_ scene: UIScene) {    }

    func sceneWillEnterForeground(_ scene: UIScene) {    }

    func sceneDidEnterBackground(_ scene: UIScene) {    }


}

