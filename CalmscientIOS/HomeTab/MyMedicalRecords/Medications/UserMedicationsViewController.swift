//
//  UserMedicationsViewController.swift
//  MainTabBarApp
//
//  Created by KA on 13/03/24.
//

import UIKit
import FSCalendar

class UserMedicationsViewController: ViewController, CalendarToViewDelegate {
    
    var networkHandler:NetworkAPIRequest = NetworkAPIRequest()
    @IBOutlet weak var calendar: CustomCalender!
    @IBOutlet weak var addMedicationsButton: UIButton!
    @IBOutlet weak var saveButton: LinearGradientButton!
    @IBOutlet weak var medicationsTableView: UITableView!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    var medicationData:[MedicineDetails] = [] {
        didSet {
            self.medicationsTableView.reloadData()
        }
    }
    private var selectedNewDate:Date = Date()
    var nomedications = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.calendarToViewDelegate = self
        addMedicationsButton.imageView?.contentMode = .scaleAspectFill
        medicationsTableView.register(UINib(nibName: "UserMedicationsTableCell", bundle: nil), forCellReuseIdentifier: "UserMedicationsTableCell")
        medicationsTableView.dataSource = self
        medicationsTableView.delegate = self
        getMedicationsData(forDate: Date())
        
        
        nomedications.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "No medications for this date" : "No hay medicamentos para esta fecha."
        nomedications.textColor = .purple
        nomedications.textAlignment = .center
        nomedications.font = UIFont.boldSystemFont(ofSize: 17)

                // Add the label to the view
        view.addSubview(nomedications)

                // Disable autoresizing mask translation
        nomedications.translatesAutoresizingMaskIntoConstraints = false

                // Center the label horizontally and vertically
                NSLayoutConstraint.activate([
                    nomedications.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    nomedications.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
        self.nomedications.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didClickOnAddMedications(_ sender: Any) {
        let next = UIStoryboard(name: "AddUserMedications", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "AddUserMedicationsViewController") as? AddUserMedicationsViewController
        vc?.refreshControlClosure = {[weak self] flag in
            self?.getMedicationsData(forDate: self?.selectedNewDate ?? Date())
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {//kiran diagnostics
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false;
        self.title = AppHelper.getLocalizeString(str:"Medications")
        saveButton.setAttributedTitleWithGradientDefaults(title: AppHelper.getLocalizeString(str:"Save"))
    }
    
    func calendardidChangeBounds(newBounds: CGRect) {
        calendarHeightConstraint.constant = newBounds.height
    }
   // func setUpLabel(){
        
       // let label = UILabel()
    
   // }
    func userSelectedNewDate(selectedDate: Date) {
        self.medicationData = []
        selectedNewDate = selectedDate
        getMedicationsData(forDate: selectedDate)
    }

    func getMedicationsData(forDate:Date) {
        self.view.showToastActivity()
        var prepareRequestBodyParams:[String:Any] = [:]
        guard let loginResponse = ApplicationSharedInfo.shared.loginResponse else {
            return
        }
        prepareRequestBodyParams["patientLocationId"] = loginResponse.patientLocationID
        prepareRequestBodyParams["patientId"] = loginResponse.patientID
        prepareRequestBodyParams["clientId"] = loginResponse.clientID
        
        let tomorrowDate = selectedNewDate.getTomorrowDate()
//        prepareRequestBodyParams["fromDate"] = "05/12/2024"
//        prepareRequestBodyParams["toDate"] = "05/13/2024"

        prepareRequestBodyParams["fromDate"] = selectedNewDate.dateInMMDDYYYYFormat()
        prepareRequestBodyParams["toDate"] = tomorrowDate.dateInMMDDYYYYFormat()
        let questonariesRequest = GetMedicationsRequestForm(prepareRequestBodyParams)
        guard let requestURL = questonariesRequest.getURLRequest() else {
            self.view.showToast(message: "An Unknown error occured. Please check with Admin")
            return
        }
        NetworkAPIRequest.sendRequest(request: requestURL) { [weak self](response: MedicationDetailsResponse?, failureResponse: FailureResponse?, error: Error?) in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.view.hideToastActivity()
                if let err = error {
                    self.view.showToast(message: err.localizedDescription)
                    
                } else if let response = response {
                    if response.response.responseCode != 200 {
                        self.view.showToast(message: response.response.responseMessage)
                        self.saveButton.isHidden = true
                    } else if response.response.responseMessage == "No Records" || response.totalRecords == 0 {
                        
                        print("Total Records: \(response.totalRecords)")

                        self.nomedications.isHidden = false
                       // self.view.showToast(message: "No medications for this date")
                        self.saveButton.isHidden = true
                        self.saveButton.isEnabled = false
                        self.medicationsTableView.reloadData()
                    } else if response.totalRecords != 0 {
                        self.medicationData = response.medicineDetails.filter({ obj in
                            let dateString = self.selectedNewDate.dateToString(format: "yyyy-MM-dd")
                            print("dateString is \(dateString)")
                            self.nomedications.isHidden = true
                            self.saveButton.isHidden = false
                            self.saveButton.isEnabled = true
                            self.medicationsTableView.reloadData()
                            return obj.date == dateString
                        })
                    }
                } else if let failureResponse = failureResponse {
                    self.view.showToast(message: failureResponse.statusResponse.responseMessage)
                }
            }
        }
    }
}

extension UserMedicationsViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMedicationsTableCell", for: indexPath) as! UserMedicationsTableCell
        cell.selectionStyle = .none
        cell.updateCellWith(MedicalDetails: medicationData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 116
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let next = UIStoryboard(name: "MedicationDetail", bundle: nil)
        let vc = next.instantiateViewController(withIdentifier: "MedicationsDetailViewController") as? MedicationsDetailViewController
        vc?.medicineDetails = medicationData[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

