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
    
    @IBOutlet weak var areYouReadyLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        managingTextView.font = UIFont(name: Fonts().lexendLight, size: 16)
        letsBeginButton.titleLabel?.font = UIFont(name: Fonts().lexendSemiBold, size: 18)
        titleLabel.font = UIFont(name: Fonts().lexendSemiBold, size: 18)
        // Do any additional setup after loading the view.
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        letsBeginButton.setTitle(UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Let's begin!" : "¡Empecemos!", for: .normal)
        areYouReadyLbl.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Are you ready?" : "¿Estás listo?"
        managingTextView.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "The Calmscient discovery will only be as effective as you make it.   So be determined to dedicate time to following along and completing the exercises. Each section has interesting and informative content that is designed to keep you actively thinking about your specific challenges. But, like taking a road trip to an unknown destination, you’ll need to be committed to following the map! It may be a little more work than you’re used to, but it will absolutely pay off in the end." : "El descubrimiento de Calmscient será tan efectivo como usted lo haga.   Así que esté decidido a dedicar tiempo a seguir y completar los ejercicios. Cada sección tiene contenido interesante e informativo diseñado para mantenerlo pensando activamente en sus desafíos específicos. Pero, al igual que hacer un viaje por carretera a un destino desconocido, ¡deberás comprometerte a seguir el mapa! Puede que suponga un poco más de trabajo del que estás acostumbrado, pero al final dará sus frutos."
        titleLabel.text =
        UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ?  "Managing Anxiety" : "Manejo de la Ansiedad"
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func letBeginButtonAction(_ sender: Any) {
        let next = UIStoryboard(name: "CourseViewController", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "CoursesViewController") as? CoursesViewController
        vc?.title = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ?  "Managing Anxiety" : "Manejo de la Ansiedad"
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
