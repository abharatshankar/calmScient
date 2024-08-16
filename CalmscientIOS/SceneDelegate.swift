//
//  SceneDelegate.swift
//  CalmscientIOS
//
//  Created by KA on 22/04/24.
//

import UIKit

@available(iOS 16.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func changeToUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
        if let window = self.window {
            window.overrideUserInterfaceStyle = style
        }
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let homeController = UIStoryboard(name: "LoginVC", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navC = UINavigationController(rootViewController: homeController)
        navC.navigationBar.isHidden = true
        window?.rootViewController = navC
        window?.makeKeyAndVisible()
        
        
        
        if let isDarkMode = UserDefaults.standard.value(forKey: "isDarkMode") as? Bool {
                let style: UIUserInterfaceStyle = isDarkMode ? .dark : .light
                changeToUserInterfaceStyle(style)
            }
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//        window?.windowScene = windowScene
//        let homeController = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
//        let navC = UINavigationController(rootViewController: homeController)
//        navC.navigationBar.isHidden = true
//        window?.rootViewController = navC
//        window?.makeKeyAndVisible()

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    
    func changeRootViewControllerToTabBar() {
            guard let window = self.window else { return }
            let homeController = UIStoryboard(name: "AppTabBar", bundle: nil).instantiateViewController(withIdentifier: "AppMainTabViewController") as! AppMainTabViewController

            
            window.rootViewController = homeController
            window.makeKeyAndVisible()
            
            let options: UIView.AnimationOptions = .transitionFlipFromRight
            UIView.transition(with: window, duration: 0.5, options: options, animations: nil, completion: nil)
        }

    
}

