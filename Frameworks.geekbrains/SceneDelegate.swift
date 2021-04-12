//
//  SceneDelegate.swift
//  Frameworks.geekbrains
//
//  Created by Nikolai Ivanov on 31.03.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let loginViewController = LoginViewController()
        window.rootViewController = loginViewController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        hidePrivacyProtectionWindow()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        showPrivacyProtectionWindow()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    private var privacyProtectionWindow: UIWindow?
    
    private func showPrivacyProtectionWindow() {
        guard let windowScene = self.window?.windowScene else { return }
        
        privacyProtectionWindow = UIWindow(windowScene: windowScene)
        privacyProtectionWindow?.rootViewController = ProtectionViewController()
        privacyProtectionWindow?.makeKeyAndVisible()
    }
    
    private func hidePrivacyProtectionWindow() {
        privacyProtectionWindow?.isHidden = true
        privacyProtectionWindow = nil
    }
}

