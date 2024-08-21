//
//  ManagingAnxietyBeginScreen.swift
//  CalmscientIOS
//
//  Created by BVK on 21/08/24.
//

import UIKit

class ManagingAnxietyBeginScreen: UIViewController {

    @IBOutlet weak var letsBeginButton: LinearGradientButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var managingTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        managingTextView.font = UIFont(name: Fonts().lexendLight, size: 16)
        letsBeginButton.titleLabel?.font = UIFont(name: Fonts().lexendSemiBold, size: 18)
        titleLabel.font = UIFont(name: Fonts().lexendSemiBold, size: 18)
        // Do any additional setup after loading the view.
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func letBeginButtonAction(_ sender: Any) {
        let next = UIStoryboard(name: "CourseViewController", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "CoursesViewController") as? CoursesViewController
        vc?.title = "Managing Anxiety"
        vc?.courseID = 2
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
