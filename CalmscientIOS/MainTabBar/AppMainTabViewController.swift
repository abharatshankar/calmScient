//
//  AppMainTabViewController.swift
//  MainTabBarApp
//
//  Created by KA on 13/03/24.
//

import UIKit

@available(iOS 16.0, *)
class AppMainTabViewController: UITabBarController {

    let tabTitles:[String] = ["HOME","DISCOVERY","EXERCISES","REWARDS"]
    let selectedImages:[String] =  ["MainTab_Home_Selected","MainTab_Discovery_Selected","MainTab_Exercises_Selected","MainTab_Rewards_Selected"]
    let unselectedimages:[String] = ["MainTab_Home_Unselected","MainTab_Discovery_Unselected","MainTab_Exercises_Unselected","MainTab_Rewards_UnSelected"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UITabBar.appearance().barTintColor = UIColor(named: "TabBarUnSelectedColor")
//        UITabBar.appearance().tintColor = UIColor(named: "TabBarSelectedColor")
//        UITabBar.appearance().isTranslucent = true
        
        if #available(iOS 15, *) {
            let tabBarItemAppearence = UITabBarItemAppearance()
            tabBarItemAppearence.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TabBarUnSelectedColor")!, NSAttributedString.Key.font: UIFont(name: Fonts().lexendRegular, size: 9)!]
            tabBarItemAppearence.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TabBarSelectedColor")!, NSAttributedString.Key.font: UIFont(name: Fonts().lexendRegular, size: 9)!]
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(named: "TabBarBackgroundColor")
            tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearence
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        prepareTabs()
        delegate = self
        // Do any additional setup after loading the view.
    }
    
    
//    let next = UIStoryboard(name: "UserIntro", bundle: nil)
//    let vc = next.instantiateViewController(withIdentifier: "UserIntroDayFeedbackViewController") as? UserIntroDayFeedbackViewController
//    vc?.afternoonVC = false
//    vc?.titleString = "Good Morning"
    
    private func prepareTabs() {
        print("prepare Tabs")
        var tabVC:[UIViewController] = []
        
        let vc1 = UIStoryboard(name: "DashboardHomeTab", bundle: nil).instantiateViewController(withIdentifier: "HomeTabDashboardViewController") as! HomeTabDashboardViewController
        let navC = UINavigationController(rootViewController: vc1)
        
        let item1 = navC
        let icon1 = UITabBarItem(title: "\(tabTitles[0])", image: UIImage(named: "\(unselectedimages[0])"), selectedImage: UIImage(named: "\(selectedImages[0])"))
        
        item1.tabBarItem = icon1
        tabVC.append(item1)
        
        let vcz = UIStoryboard(name: "DiscoveryMainDashboard", bundle: nil).instantiateViewController(withIdentifier: "DiscoveryMainViewController") as! DiscoveryMainViewController
        let navC2 = UINavigationController(rootViewController: vcz)
        
        let item2 = navC2
        let icon2 = UITabBarItem(title: "\(tabTitles[1])", image: UIImage(named: "\(unselectedimages[1])"), selectedImage: UIImage(named: "\(selectedImages[1])"))
        item2.tabBarItem = icon2
        tabVC.append(item2)
        
        
        
        
//        let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
////
////                // 2. Instantiate the destination view controller using its Storyboard ID
//                if let destinationVC = storyboard.instantiateViewController(withIdentifier: "Excercises") as? Excercises {
//                    
//                    // 3. Push the destination view controller onto the navigation stack
//                    self.navigationController?.pushViewController(destinationVC, animated: true)
//                }else{
//                    print("incorrect nav")
//                }
        
        let vcz3 = UIStoryboard(name: "Excercises", bundle: nil).instantiateViewController(withIdentifier: "Excercises") as! Excercises
        let navC3 = UINavigationController(rootViewController: vcz3)
        
        
        let item3 = navC3
        let icon3 = UITabBarItem(title: "\(tabTitles[2])", image: UIImage(named: "\(unselectedimages[2])"), selectedImage: UIImage(named: "\(selectedImages[2])"))
        item3.tabBarItem = icon3
        tabVC.append(item3)
        
        let item4 = TestViewController4()
        let icon4 = UITabBarItem(title: "\(tabTitles[3])", image: UIImage(named: "MainTab_Rewards_UnSelected"), selectedImage: UIImage(named: "MainTab_Rewards_Selected"))
        item4.tabBarItem = icon4
        tabVC.append(item4)
        
        self.viewControllers = tabVC
    }
    
    private func updateTabBarAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "TabBarUnSelectedColor")!, NSAttributedString.Key.font: UIFont(name: Fonts().lexendRegular, size: 9)!], for: .normal)
            
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "TabBarSelectedColor")!, NSAttributedString.Key.font:UIFont(name: Fonts().lexendRegular, size: 9)!], for: .selected)
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "TabBarBackgroundColor")
    }

}

@available(iOS 16.0, *)
extension AppMainTabViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return true;
    }
}

class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        print("item 1 loaded")
    }
}

class TestViewController2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.randomColor()
        print("item 1 loaded")
    }
}

class TestViewController3: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.randomColor()
        print("item 1 loaded")
    }
}

//class TestViewController3: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = UIColor.white
//        print("item 1 loaded")
//        
//        // Load the image
//        guard let image = UIImage(named: "comingsoon.png") else {
//            print("Image not found")
//            return
//        }
//        
//        // Create and configure the UIImageView
//        let imageView = UIImageView(image: image)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
//        
//        // Add the UIImageView to the view
//        view.addSubview(imageView)
//        
//        // Set up constraints to center the UIImageView
//        NSLayoutConstraint.activate([
//            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: 300), // Adjust the width as needed
//            imageView.heightAnchor.constraint(equalToConstant: 200) // Adjust the height as needed
//        ])
//    }
//}
class TestViewController4: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        print("item 1 loaded")
        
        // Load the image
        guard let image = UIImage(named: "comingsoon.png") else {
            print("Image not found")
            return
        }
        
        // Create and configure the UIImageView
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        // Add the UIImageView to the view
        view.addSubview(imageView)
        
        // Set up constraints to center the UIImageView
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300), // Adjust the width as needed
            imageView.heightAnchor.constraint(equalToConstant: 200) // Adjust the height as needed
        ])
    }
}

extension UIColor {
    class func randomColor(randomAlpha: Bool = false) -> UIColor {
        let redValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let greenValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let blueValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let alphaValue = randomAlpha ? CGFloat(arc4random_uniform(255)) / 255.0 : 1;

        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
    }
}
