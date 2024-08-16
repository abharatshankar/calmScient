//
//  ViewController.swift
//  CalmscientIOS
//
//  Created by KA on 22/04/24.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.shadowImage = UIColor(named: "AppBackGroundColor")?.as1ptImage()
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-5, for: .default)
        self.navigationItem.backButtonTitle = ""

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        DispatchQueue.main.async {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "TabBarUnSelectedColor")!, NSAttributedString.Key.font: UIFont(name: Fonts().lexendRegular, size: 9)!], for: .normal)
            UITabBar.appearance().isTranslucent = true
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "TabBarSelectedColor")!, NSAttributedString.Key.font:UIFont(name: Fonts().lexendRegular, size: 9)!], for: .selected)
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: Fonts().lexendMedium, size: 20)!]

            let backImage = UIImage(named: "NavigationBack")
            UINavigationBar.appearance().backIndicatorImage = backImage
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
            UINavigationBar.appearance().backItem?.backButtonTitle = ""
        }
        self.view.setNeedsDisplay()
    }
}


