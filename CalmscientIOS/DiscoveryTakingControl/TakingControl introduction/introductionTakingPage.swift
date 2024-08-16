//
//  introductionTakingPage.swift
//  CalmscientIOS
//
//  Created by mac on 28/05/24.
//

import Foundation
import UIKit
@available(iOS 16.0, *)
class introductionTakingPage: ViewController {
    
    
    
    
    @IBOutlet weak var infoButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func back_action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func infoTapped(_ sender: UIButton) {
        let next = UIStoryboard(name: "IntroductionPageController", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "IntroductionPageController") as? IntroductionPageController
        vc?.title = "Taking control introduction"
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}
