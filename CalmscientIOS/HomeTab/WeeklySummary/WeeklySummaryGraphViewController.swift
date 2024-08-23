//
//  SummaryOfMoodViewController.swift
//  CalmscientIOS
//
//  Created by NFC on 01/05/24.
//

import UIKit



class WeeklySummaryGraphViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var needToTalkSomeOneButton: LinearGradientButton!
    
    private let hardCodedStartDate:String = "05/12/2024"
    private let hardCodedEndDate:String = "05/27/2024"
    
    
    var summaryType:WeeklySummaryItems = .WeeklySummarySummaryOfMood {
        didSet {
            self.tableDataList = summaryType.getTableCellList()
        }
    }
    
    private let dateDifference = -15
    
    var dateRange:(fromDate:Date, toDate:Date) = (Date().getOlderDateWithDaysDifference(minusDays: -30), Date())
    var chartData:[GraphData] = []
    var tableDataList:[WeeklySummaryGraphViewTableCell] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLanguage()
        let needToTalk = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Need to talk with someone?" : "¿Necesitas hablar con alguien?"
        needToTalkSomeOneButton.setAttributedTitleWithGradientDefaults(title: needToTalk)
        tableView.register(UINib(nibName: "ChartViewHeaderTableCell", bundle: nil), forCellReuseIdentifier: "ChartViewHeaderTableCell")
        tableView.register(UINib(nibName: "ChartViewTableCell", bundle: nil), forCellReuseIdentifier: "ChartViewTableCell")
        getDataFromAPI()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        setupLanguage()
    }
    func setupLanguage() {
        
        let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
        
        if languageId == 1 {
            UserDefaults.standard.set("en", forKey: "Language")
        } else if languageId == 2 {
            UserDefaults.standard.set("es", forKey: "Language")
        }
    }
    @IBAction func needToTalkButtonAction(_ sender: Any) {
        let next = UIStoryboard(name: "NeedToTalkViewController", bundle: nil)
               let vc = next.instantiateViewController(withIdentifier: "NeedToTalkViewController") as? NeedToTalkViewController
               vc?.title = "Emergency resource"
               self.navigationController?.pushViewController(vc!, animated: true)
    }
    private func getDataFromAPI() {
        self.view.showToastActivity()
        tableDataList = summaryType.getTableCellList()
        summaryType.getServerResponsefrom(startDate: dateRange.fromDate.dateToString(format: "MM/dd/yyyy"), and: dateRange.toDate.dateToString(format: "MM/dd/yyyy")) { [weak self] graphData, serverResponse, error in
            self?.view.hideToastActivity()
            guard let responseData = graphData else {
                return
            }
            self?.chartData = responseData
            self?.tableView.reloadData()
        }
    }

    private func prepareBarChartData(data:[GraphData]) -> [GraphData] {
        let excellentData = data.filter { obj in
            return obj.additionalInfo?.lowercased().trimmingCharacters(in: .whitespaces) == "EXCELLENT".lowercased()
        }
        let goodData = data.filter { obj in
            return obj.additionalInfo?.lowercased().trimmingCharacters(in: .whitespaces) == "GOOD".lowercased()
        }
        let fairData = data.filter { obj in
            return obj.additionalInfo?.lowercased().trimmingCharacters(in: .whitespaces) == "FAIR".lowercased()
        }
        let couldbeBetterData:[GraphData] = data.filter { obj in
            return obj.additionalInfo?.lowercased().trimmingCharacters(in: .whitespaces) == "COULD BE BETTER".lowercased()
        }
        let badData:[GraphData] = data.filter { obj in
            return obj.additionalInfo?.lowercased().trimmingCharacters(in: .whitespaces) == "BAD".lowercased()
        }
        var preparedData:[GraphData] = []
        preparedData.append(GraphData(yAxisValue: excellentData.count, xAxisValue: "EXCELLENT", additionalInfo: "EXCELLENT", graphType: .WeeklySummarySummaryOfMood))
        preparedData.append(GraphData(yAxisValue: goodData.count, xAxisValue: "GOOD", additionalInfo: "GOOD", graphType: .WeeklySummarySummaryOfMood))
        preparedData.append(GraphData(yAxisValue: fairData.count, xAxisValue: "FAIR", additionalInfo: "FAIR", graphType: .WeeklySummarySummaryOfMood))
        preparedData.append(GraphData(yAxisValue: couldbeBetterData.count, xAxisValue: "COULD BE BETTER", additionalInfo: "GOOD", graphType: .WeeklySummarySummaryOfMood))
        preparedData.append(GraphData(yAxisValue: badData.count, xAxisValue: "BAD", additionalInfo: "BAD", graphType: .WeeklySummarySummaryOfMood))
        return preparedData
    }

}

extension WeeklySummaryGraphViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryType.getTableCellList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartViewHeaderTableCell", for: indexPath) as? ChartViewHeaderTableCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartViewTableCell", for: indexPath) as? ChartViewTableCell else {
                return UITableViewCell()
            }
            if indexPath.row == 1 {
                if self.title == "Summary Of PHQ9" {
                    cell.chartViewTitleLabel.text = "PHQ-9 by Date Range"
                } else {
                    cell.chartViewTitleLabel.text = "Mood by Date Range"
                }
                if chartData.count > 0 {
                    cell.setupMoodLineChartView(graphData: chartData)
                }
            } else {
                cell.chartViewTitleLabel.text = "Days at each Mood"
                cell.setupbarChartView(data: self.prepareBarChartData(data: chartData))
            }
            cell.selectionStyle = .none
            return cell
        }*/
        let cellType = tableDataList[indexPath.row]
        
        switch cellType {
            
        case .GraphSelectionTableHeaderCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartViewHeaderTableCell", for: indexPath) as? ChartViewHeaderTableCell else {
                return UITableViewCell()
            }
            cell.userSelectedNewDates = { [weak self] (fromDate, toDate) in
                self?.dateRange = (fromDate,toDate)
                self?.chartData = []
                self?.tableView.reloadData()
                self?.getDataFromAPI()
            }
            cell.selectionStyle = .none
            return cell
        case .WeeklySummaryGraphViewCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartViewTableCell", for: indexPath) as? ChartViewTableCell else {
                return UITableViewCell()
            }
            cell.chartViewTitleLabel.text = summaryType.localized
            if summaryType == .WeeklySummarySummaryOfMood {
                cell.setupMoodLineChartView(graphData: chartData)
            } else {
                cell.setupLineChartView(graphDataValues: chartData)
            }
            return cell
        case .WeeklySummaryBarChartViewCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartViewTableCell", for: indexPath) as? ChartViewTableCell else {
                return UITableViewCell()
            }
            cell.chartViewTitleLabel.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? "Days at each Mood" : "Días en cada estado de ánimo"
            cell.setupbarChartView(data: self.prepareBarChartData(data: chartData))
            return cell
        }
       return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return summaryType.getTableCellList()[indexPath.row].getCellHeight()
    }
    
}
