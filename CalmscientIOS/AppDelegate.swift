//
//  AppDelegate.swift
//  CalmscientIOS
//
//  Created by KA on 22/04/24.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        checkNotificationPermission()
        DispatchQueue.main.async {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "TabBarUnSelectedColor")!, NSAttributedString.Key.font: UIFont(name: Fonts().lexendRegular, size: 9)!], for: .normal)
            UITabBar.appearance().isTranslucent = true
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "TabBarSelectedColor")!, NSAttributedString.Key.font:UIFont(name: Fonts().lexendRegular, size: 9)!], for: .selected)
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: Fonts().lexendMedium, size: 20)!]
            
            if let navBar = UINavigationBar.appearance() as? UINavigationBar {
                let bottomBorder = UIView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: 1))
                bottomBorder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                navBar.addSubview(bottomBorder)
            }
            
            
            let backImage = UIImage(named: "NavigationBack")
            UINavigationBar.appearance().backIndicatorImage = backImage
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
            UINavigationBar.appearance().backItem?.backButtonTitle = ""
            
            if UserDefaults.standard.object(forKey: "Language") != nil && UserDefaults.standard.object(forKey: "Language") as! String == "es"
            {
                UserDefaults.standard.set("es", forKey: "Language")
            }
            else
            {
                UserDefaults.standard.set("en", forKey: "Language")
            }
            
            
            var languageId: Int? = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
            languageId = (languageId == 0) ? 1 : languageId
            UserDefaults.standard.set(languageId , forKey: "SelectedLanguageID")
            
            
            if languageId == 1 {
                UserDefaults.standard.set("en", forKey: "Language")
            } else if languageId == 2 {
                UserDefaults.standard.set("es", forKey: "Language")
            }
            
        }
        return true
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission not granted")
                DispatchQueue.main.async {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }
                }
            }
        }
    }
    

    
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // Permission not requested yet, request permission
                self.requestNotificationPermission()
            case .denied:
                // Permission was denied, show an alert to guide the user to settings
                DispatchQueue.main.async {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }
                }
            case .authorized, .provisional, .ephemeral:
                // Permission granted or in provisional state
                print("Permission granted")
            @unknown default:
                break
            }
        }
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

extension UIApplication {
    
    // Function to get the topmost view controller
    class func getTopViewController(base: UIViewController? = UIApplication.shared.getKeyWindow()?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    private func getKeyWindow() -> UIWindow? {
        if #available(iOS 13, *) {
            // For iOS 13 and later
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            // For iOS 12 and earlier
            return UIApplication.shared.keyWindow
        }
    }
    
}
