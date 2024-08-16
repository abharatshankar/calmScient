import UIKit

protocol InfoAlertViewActionProtocol: AnyObject {
    
    func didClickOnCancelButton()
}

class InfoAlert: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var infotableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var alertActionDelegate: InfoAlertViewActionProtocol?
    
    // Sample data for the table view
    var infoItems: [String] =  ["AUDIT","DUST-10","CAGE"]
    var infoalertItems: [String] = ["(Alcohol Use Disorder Identification Test)", "(Drug Abuse Screening Test)", "(Cut, Annoyed, Guilty and Eye)"]
    var details_value: [String] = ["Do you enjoy a drink now or then? Many of us do, often when socializing with friends and family. Let's take a look at your drinking patterns and how they may affect your health.The AUDIT questionnaire is designed to help in the self-assessment of alcohol consumption and to identify any implications for the person's health and well being, now and in the future. Conduct a quick self-test with AUDIT above. Click on \("Submit") at the end for an instant assessment.", "\("Drug use") refers to the use of prescribed or over-the-counter drugs in excess of the directions, and any non medical use of drugs.The various classes of drugs may include cannabis (marijuana, hashish), solvents (e.g., paint thinner), tranquilizers (e.g., valium), barbiturates, cocaine, stimulants (e.g., speed), hallucinogens (e.g., LSD) or narcotics (e.g., heroin). The questions do not include alcoholic beverages. Please answer the questions in this survey. If you have difficulty with a statement, simply choose the best response possible. These questions refer to drug use in the past 12 months. Please answer NO or YES to each question.", "The CAGE questionnaire for smoking (modified from the familiar CAGE questionnaire for alcoholism), the \("four Cs") test and the Fagerström Test for Nicotine Dependence help diagnose nicotine dependence based on standard criteria. Additional questions can  be used to determine a patient's readiness to change and the nature of reinforcement the patient receives  from smoking. These tools can assist family physicians in guiding patients to quit smoking-the single most important thing smokers can do to improve their health."]
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib(nibName: "InfoAlert")
        setupTableView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib(nibName: "InfoAlert")
        setupTableView()
    }
    
    private func loadViewFromNib(nibName: String) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(view)
    }
    
    private func setupTableView() {
        infotableView.delegate = self
        infotableView.dataSource = self
        //        infotableView.register(UITableViewCell.self, forCellReuseIdentifier: "InfoAlertCell")
        infotableView.register(UINib(nibName: "InfoAlertCell", bundle: nil), forCellReuseIdentifier: "InfoAlertCell")
    }
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoAlertCell", for: indexPath) as! InfoAlertCell
        cell.name_label?.text = infoItems[indexPath.row]
        cell.caption_label.text = infoalertItems[indexPath.row]
        cell.description_label.text = details_value[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    // UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected \(infoItems[indexPath.row])")
    }
    
    @IBAction func didClickOnCancelButton(_ sender: UIButton) {
        alertActionDelegate?.didClickOnCancelButton()
       
      //  self.removeFromSuperview()
    }
    
    
}
