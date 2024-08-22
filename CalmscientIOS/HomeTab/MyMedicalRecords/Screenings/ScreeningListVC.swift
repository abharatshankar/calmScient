//
//  ScreeningListVC.swift
//  HealthScreeningApp
//
//  Created by KA on 22/03/24.
//

import UIKit

class ScreeningListVC: ViewController {
    
    var networkHandler:NetworkAPIRequest = NetworkAPIRequest()
    let screeningRequest = ScreeningListRequestForm()
    @IBOutlet weak var screeningListTable: UITableView!
    
    var screeningData:[Screening] = [] {
        didSet {
            self.screeningListTable.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        screeningListTable.register(UINib(nibName: "ScreeningCell", bundle: nil), forCellReuseIdentifier: "ScreeningCell")
        self.screeningListTable.delegate = self
        self.screeningListTable.dataSource = self
        self.view.showToastActivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Screenings" : "Exámenes"
        getScreeningData()
        
    }
    
    func getScreeningData() {
        screeningData = []
        guard let requestURL = screeningRequest.getURLRequest() else {
            self.view.showToast(message: "An Unknown error occured. Please check with Admin")
            return
        }
        NetworkAPIRequest.sendRequest(request: requestURL) { [weak self](response: ScreeningResponse?, failureResponse: FailureResponse?, error: Error?) in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.view.hideToastActivity()
                if let _ = error {
                    self.view.showToast(message: "An Unknown error occured. Please check with Admin")
                } else if let response = response {
                    self.screeningData = response.screeningList
                } else if let failureResponse = failureResponse {
                    self.view.showToast(message: failureResponse.statusResponse.responseMessage)
                }
            }
            
        }
    }
}

extension ScreeningListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screeningData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:ScreeningCell = self.screeningListTable.dequeueReusableCell(withIdentifier: "ScreeningCell") as? ScreeningCell else {
            return UITableViewCell()
        }
        let data = screeningData[indexPath.row]
        cell.configureCell(celldata: data)
        cell.selectionStyle = .none
        cell.onHistoryClick = { [weak self] in
            let next = UIStoryboard(name: "HistoryVC", bundle: nil)
            let vc = next.instantiateViewController(withIdentifier: "HistoryVC") as? HistoryVC
            vc?.selectedScreening = data
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedScreening = screeningData[indexPath.row]
        
        if selectedScreening.screeningStatus.lowercased() != "completed" {
            let next = UIStoryboard(name: "ScreeningQuestions", bundle: nil)
            let vc = next.instantiateViewController(withIdentifier: "ScreeningQuestionsViewController") as? ScreeningQuestionsViewController
            vc?.selectedScreening = screeningData[indexPath.row]
            
            print("screeningData===\(screeningData)")
            
            vc?.screeningAllQuestionsSuccessfullySubmittedClosure = { [weak self] obj in
                guard let self = self else {
                    return
                }
                let next = UIStoryboard(name: "ScreeningResultVC", bundle: nil)
                let vc = next.instantiateViewController(withIdentifier: "ScreeningResultVC") as? ScreeningResultVC
                vc?.selectedScreening = obj
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let next = UIStoryboard(name: "HistoryVC", bundle: nil)
            let vc = next.instantiateViewController(withIdentifier: "HistoryVC") as? HistoryVC
            vc?.selectedScreening = screeningData[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}


