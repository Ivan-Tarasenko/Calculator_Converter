//
//  SceneDelegate.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
//    var viewmodel: ViewModelProtocol = ViewModel()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
//    func sceneDidBecomeActive(_ scene: UIScene) {
//        viewmodel.setData()
//    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
