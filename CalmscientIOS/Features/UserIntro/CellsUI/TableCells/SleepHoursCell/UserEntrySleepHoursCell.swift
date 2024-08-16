//
//  UserEntrySleepHoursCell.swift
//  HealthApp
//
//  Created by KA on 28/02/24.
//

import UIKit

class UserEntrySleepHoursCell: UITableViewCell {

    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sleepHoursCollectionView: UICollectionView!
    let selectedBorderColor = UIColor(named: "circleCellSelectedColor")
    let defaultBorderColor = UIColor(named: "circleIntroBorderColor")
    let selectedTextColor = UIColor.white
    let defaultTextColor = UIColor(named: "circleTextColor")
    let selectedFillColor = UIColor(named: "circleCellSelectedColor")
    let defaultFillColor = UIColor(named: "circleFillColor")
    let sleepData = ["Less","4","5","6","7","8","9","10","More"]
    var selectedIndex = -1
    
    private var cellType:UserEntryDayFeedbackTableCell!
    private var instance:UserStartupScreenDayData!
    
    let colors = [UIColor(named: "medicationsWeekCellColor"),UIColor(named: "medicationsWeekCellColor"),UIColor(named: "medicationscelldefaulttextcolor"),UIColor(named: "medicationsSelectedColor"),UIColor(named: "medicationsSelectedColor"),UIColor.white]
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadowAndBorder()
        let nib = UINib(nibName: "UserEntrySleepCell", bundle: nil)
        sleepHoursCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        sleepHoursCollectionView.register(CustomOvalCollectionViewCell.self, forCellWithReuseIdentifier: "CustomOvalCollectionViewCell")
        sleepHoursCollectionView.register(nib, forCellWithReuseIdentifier: "UserEntrySleepCell")
        if let layout = sleepHoursCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }

        // Initialization code
    }
    
    func updateUIWithCellInstance(instance:UserStartupScreenDayData, cellType:UserEntryDayFeedbackTableCell) {
        self.instance = instance
        self.cellType = cellType
        let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
        
        self.titleLabel.text = languageId == 1 ? instance.sleepData?.sleepQuestion : "¿Cuántas horas dormiste anoche?"
        sleepHoursCollectionView.delegate = self
        sleepHoursCollectionView.dataSource = self
        sleepHoursCollectionView.reloadData()
    }
    
    fileprivate func addShadowAndBorder() {
        shadowView.layer.backgroundColor = UIColor.clear.cgColor
        shadowView.layer.shadowColor = UIColor(named: "AppViewShadowColor")?.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 2.0
        
        cornerView.layer.cornerRadius = 8
        cornerView.layer.masksToBounds = true
        cornerView.layer.borderWidth = 1
        cornerView.layer.borderColor = UIColor(named: "AppViewBorderColor")?.cgColor
    }

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UserEntrySleepHoursCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sleepData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 || indexPath.row == 8 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
                return UICollectionViewCell()
            }
            if indexPath.row == selectedIndex {
                cell.circleStrokeColor = selectedBorderColor
                cell.circleFillColor = selectedFillColor
                cell.contentTextColor = UIColor.white
            } else {
                cell.circleStrokeColor = defaultBorderColor
                cell.circleFillColor = defaultFillColor
                cell.contentTextColor = defaultTextColor
            }
            
            cell.setCircleText(text: sleepData[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomOvalCollectionViewCell", for: indexPath) as? CustomOvalCollectionViewCell else {
                return UICollectionViewCell()
            }
            if indexPath.row == selectedIndex {
                cell.circleStrokeColor = selectedBorderColor
                cell.circleFillColor = selectedFillColor
                cell.contentTextColor = UIColor.white
            } else {
                cell.circleStrokeColor = defaultBorderColor
                cell.circleFillColor = defaultFillColor
                cell.contentTextColor = defaultTextColor
            }
            cell.setCircleText(text: sleepData[indexPath.row])
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the size of each item in your collection view
        let possibleHeight = collectionView.frame.height - 10
        let availWidth = (collectionView.frame.width - (8*5) - 10)
        let possibleWidth = availWidth / 9
        let squareWidth = min(possibleWidth, possibleHeight)
        let widthDifference = squareWidth - possibleWidth
        return CGSize(width: squareWidth, height: squareWidth)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    
}

extension UserEntrySleepHoursCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if selectedIndex == 0 {
            instance.sleepAnswer = 2
        } else if selectedIndex == sleepData.count - 1 {
            instance.sleepAnswer = 14
        } else {
            instance.sleepAnswer = Int(sleepData[indexPath.row])
        }
        collectionView.reloadData()
    }
}
