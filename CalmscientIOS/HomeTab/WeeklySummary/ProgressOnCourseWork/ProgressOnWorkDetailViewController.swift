//
//  ProgressOnWorkDetailViewController.swift
//  CalmscientIOS
//
//  Created by NFC on 29/04/24.
//

import UIKit

//class ProgressOnWorkDetailViewController: ViewController {
//
//    @IBOutlet weak var needToTalkSomeOneButton: LinearGradientButton!
//    private lazy var summaryResultsTableView:ProgressOnWorkExpansionTableView = {
//            return ProgressOnWorkExpansionTableView(frame: .zero)
//        }()
//    
//    var tableData:[ProgressOfWorkCellData]!
//    var progressDetailData: [[String: Any]] = []
//    var index: Int?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("index===\(String(describing: index))")
//        print("progressDetailData====\(progressDetailData[index ?? 0])")
//        self.title = "Progress on course work"
//        tableData = prepareData()
//        needToTalkSomeOneButton.setAttributedTitleWithGradientDefaults(title: "Need to talk with someone?")
//        self.view.addSubview(summaryResultsTableView)
//        summaryResultsTableView.tableData = self.tableData
//        summaryResultsTableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            summaryResultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            summaryResultsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            summaryResultsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            summaryResultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//        ])
//        self.view.bringSubviewToFront(needToTalkSomeOneButton)
//        summaryResultsTableView.reloadData()
//        // Do any additional setup after loading the view.
//    }
//    
////    private func prepareData() -> [ProgressOfWorkCellData] {
////            guard let index = index, index < progressDetailData.count,
////                  let courseData = progressDetailData[index] as? [String: Any],
////                  let sectionsList = courseData["sectionsList"] as? [[String: Any]] else {
////                return []
////            }
////
////            return sectionsList.map { section in
////                let title = section["sectionName"] as? String ?? ""
////                let subtitles = (section["subSectionList"] as? [[String: Any]])?.compactMap { $0["subSectionName"] as? String } ?? []
////                let percentages = (section["subSectionList"] as? [[String: Any]])?.compactMap { $0["completion"] as? String } ?? []
////                let titlePer = section["completions"] as? String ?? "0%"
////                return ProgressOfWorkCellData(title: title, subtitle: subtitles, percentage: percentages, titlePer: titlePer)
////            }
////        }
//    
//    private func prepareData() -> [ProgressOfWorkCellData] {
//        guard let index = index, index < progressDetailData.count,
//              let courseData = progressDetailData[index] as? [String: Any],
//              let sectionsList = courseData["sectionsList"] as? [[String: Any]] else {
//            return []
//        }
//
//        return sectionsList.map { section in
//            let title = section["sectionName"] as? String ?? ""
//            let percentages = (section["subSectionList"] as? [[String: Any]])?.compactMap { $0["completion"] as? String } ?? []
//            let titlePer = section["completions"] as? String ?? "0%"
//            return ProgressOfWorkCellData(title: title, percentage: percentages, titlePer: titlePer)
//        }
//    }
//
//
//}
class ProgressOnWorkDetailViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var needToTalkSomeOneButton: LinearGradientButton!
    private lazy var summaryResultsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ProgressCollapsableTableCell", bundle: nil), forCellReuseIdentifier: "ProgressCollapsableTableCell")
        return tableView
    }()
    var tableData: [ProgressOfWorkCellData] = []
    var progressDetailData: [[String: Any]] = []
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Progress on course work"
        tableData = prepareData()
        needToTalkSomeOneButton.setAttributedTitleWithGradientDefaults(title: "Need to talk with someone?")
        
        self.view.addSubview(summaryResultsTableView)
        NSLayoutConstraint.activate([
            summaryResultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            summaryResultsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            summaryResultsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            summaryResultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        self.view.bringSubviewToFront(needToTalkSomeOneButton)
        summaryResultsTableView.reloadData()
    }
    @IBAction func needToTalkButtonAction(_ sender: Any) {
        let next = UIStoryboard(name: "NeedToTalkViewController", bundle: nil)
               let vc = next.instantiateViewController(withIdentifier: "NeedToTalkViewController") as? NeedToTalkViewController
               vc?.title = "Emergency resource"
               self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    private func prepareData() -> [ProgressOfWorkCellData] {
        guard let index = index, index < progressDetailData.count,
              let courseData = progressDetailData[index] as? [String: Any],
              let sectionsList = courseData["sectionsList"] as? [[String: Any]] else {
            return []
        }
        
        return sectionsList.map { section in
            let title = section["sectionName"] as? String ?? ""
            let subtitles = (section["subSectionList"] as? [[String: Any]])?.compactMap { $0["subSectionName"] as? String } ?? []
            let percentages = (section["subSectionList"] as? [[String: Any]])?.compactMap { $0["completion"] as? String } ?? []
            let titlePer = section["completions"] as? String ?? "0%"
            return ProgressOfWorkCellData(title: title, subtitle: subtitles, percentage: percentages, titlePer: titlePer)
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataItem = tableData[section]
        return dataItem.exapansionState ? dataItem.subtitle.count + 1 : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataItem = tableData[indexPath.section]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressCollapsableTableCell", for: indexPath) as? ProgressCollapsableTableCell else {
            return UITableViewCell()
        }
           if indexPath.row == 0 {
       
        cell.dataItem = dataItem
        cell.cellExpansionClosure = { [weak self] isExpanded in
            guard let self = self else { return }
            if isExpanded {
                // Collapse all sections
                for item in self.tableData {
                    item.updateExpansionState(isExpanded: false)
                }
                // Expand the selected section
                dataItem.updateExpansionState(isExpanded: true)
            } else {
                // Collapse the selected section
                dataItem.updateExpansionState(isExpanded: false)
            }
            tableView.reloadData() // Reload the table view after updating the expansion state
        }
         }
        return cell

        //else {
        //                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SubsectionCell")
        //                cell.textLabel?.text = dataItem.subtitle[indexPath.row - 1]
        //                cell.detailTextLabel?.text = dataItem.percentage[indexPath.row - 1]
        //                return cell
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let dataItem = tableData[indexPath.section]
    //                if indexPath.row == 0 {
    //                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressCollapsableTableCell", for: indexPath) as? ProgressCollapsableTableCell else {
    //                        return UITableViewCell()
    //                    }
    //                    cell.dataItem = dataItem
    //                    cell.cellExpansionClosure = { isExpanded in
    //                        dataItem.updateExpansionState(isExpanded: isExpanded)
    //                        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    //                    }
    //                    return cell
    //                } else {
    //                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SubsectionCell")
    //                    cell.textLabel?.text = dataItem.subtitle[indexPath.row - 1]
    //                    cell.detailTextLabel?.text = dataItem.percentage[indexPath.row - 1]
    //                    return cell
    //                }
    //    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection if needed
    }
    
}
