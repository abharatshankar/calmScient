//
//  UserIntroSelectionTableCell.swift
//  HealthApp
//
//  Created by KA on 26/02/24.
//

import UIKit

class UserIntroSelectionTableCell: UITableViewCell {
    
    @IBOutlet weak var borderContainerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableCellCollectionView: UICollectionView!
    
    private var cellType:UserEntryDayFeedbackTableCell! {
        didSet {
            if cellType == .UserMoodHoursCell {
                self.titleLabel.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? instance.moodData?.moodQuestion  : "¿Cómo estuvo tu día?"
            } else {
                self.titleLabel.text = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? instance.timeSpendData?.timeSpendQuestion : "¿Con quién pasaste tiempo?"
            }
        }
    }
    private var instance:UserStartupScreenDayData!
    var selectedIndex = -1
    let dummyData:[String:[(String,String)]] = UserDefaults.standard.integer(forKey: "SelectedLanguageID") == 1 ? ["UserMoodHoursCell":[
        ("UserIntro_Bad","BAD"),
        ("UserIntro_Couldbe","COULD BE BETTER"),
        ("UserIntro_Fair","FAIR"),
        ("UserIntro_Good","GOOD"),
        ("UserIntro_Excellent","EXCELLENT")
    ],"UserEntryTimeSpendCell":[
        ("UserIntro_Family","FAMILY"),
        ("UserIntro_Friends","FRIENDS"),
        ("UserIntro_Workmates","WORKMATES"),
        ("UserIntro_Others","OTHERS"),
        ("UserIntro_Alone","ALONE")
    ]]
    
    :
    
    ["UserMoodHoursCell":[
        ("UserIntro_Bad","MALO"),
        ("UserIntro_Couldbe","PODRÍA SER MEJOR"),
        ("UserIntro_Fair","REGULAR"),
        ("UserIntro_Good","BUENO"),
        ("UserIntro_Excellent","EXCELENTE")
    ],"UserEntryTimeSpendCell":[
        ("UserIntro_Family","FAMILIA"),
        ("UserIntro_Friends","AMIGOS"),
        ("UserIntro_Workmates","COMPAÑEROS DE TRABAJO"),
        ("UserIntro_Others","OTROS"),
        ("UserIntro_Alone","SOLO")
    ]]
    
    let selectedSmileyImgs = ["bad_selected","could_better_selected","fair_selected","good_selected","excellent_selected"]
    
    let selectedFamilyImages = ["family_selected","friends_selected","workmates_selected","others","alone_selected"]
    
    var collectionData:[(String,String)]!
    fileprivate func addShadowAndBorder() {
        shadowView.layer.backgroundColor = UIColor.clear.cgColor
        shadowView.layer.shadowColor = UIColor(named: "AppViewShadowColor")?.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 2.0
//        shadowView.applyShadow(radius: 8)
        
        borderContainerView.layer.cornerRadius = 8
        borderContainerView.layer.masksToBounds = true
        borderContainerView.layer.borderWidth = 1
        borderContainerView.layer.borderColor = UIColor(named: "AppViewBorderColor")?.cgColor
        borderContainerView.applyShadow(cornerRadius: 8)
    }
    
//    func setupLanguage() {
//        
//            let languageId = UserDefaults.standard.integer(forKey: "SelectedLanguageID")
//            
//            if languageId == 1 {
//                UserDefaults.standard.set("en", forKey: "Language")
//            } else if languageId == 2 {
//                UserDefaults.standard.set("es", forKey: "Language")
//            }
//        self.title = AppHelper.getLocalizeString(str:"Add Medications")
//        var headingLabelString = AppHelper.getLocalizeString(str:"Add Time & Alarm")
//        saveStr = AppHelper.getLocalizeString(str: "Save")
////        change at line 48, 49,
//        }
    
    func updateUIWithCellInstance(instance:UserStartupScreenDayData, cellType:UserEntryDayFeedbackTableCell) {
        self.instance = instance
        self.cellType = cellType
        self.collectionData = dummyData[cellType.rawValue]!
        tableCellCollectionView.delegate = self
        tableCellCollectionView.dataSource = self
        tableCellCollectionView.reloadData()
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadowAndBorder()
        let nib = UINib(nibName: "UserIntroDayCollectionCell", bundle: nil)
        tableCellCollectionView.register(nib, forCellWithReuseIdentifier: "UserIntroDayCollectionCell")
        if let layout = tableCellCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        tableCellCollectionView.showsHorizontalScrollIndicator = false
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UserIntroSelectionTableCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserIntroDayCollectionCell", for: indexPath) as? UserIntroDayCollectionCell else {
            return UICollectionViewCell()
        }
        let cellData = collectionData[indexPath.row]
        if indexPath.row == selectedIndex {
            cell.cellTitleLabel.textColor = UIColor(named: "TabBarSelectedColor")
            cell.cellImageView.image =  cellType == .UserEntryTimeSpendCell ? UIImage(named: selectedFamilyImages[indexPath.row]) : UIImage(named: "\(cellData.0)")  //UIImage(named: selectedSmileyImgs[indexPath.row])
            cell.cellImageView.applyShadow()
            // UIImage(named: "\(cellData.0)")
            // Assuming cellImageView is a square view
            cell.cellImageView.layer.borderWidth = 4
            cell.cellImageView.layer.borderColor = UIColor.white.cgColor
            cell.cellImageView.layer.cornerRadius = cell.cellImageView.frame.height / 2
            cell.cellImageView.layer.masksToBounds = true
            cell.cellImageView.layer.shadowColor = UIColor.black.cgColor
            cell.cellImageView.layer.shadowOpacity = 0.5
            cell.cellImageView.layer.shadowOffset = CGSize(width: 4, height: 4)
            cell.cellImageView.layer.shadowRadius = 5
            cell.cellImageView.layer.masksToBounds = false
//            cell.cellImageView.layer.borderColor = UIColor.white.cgColor
//            cell.cellImageView.applyShadow()
        } else {
            cell.cellTitleLabel.textColor = UIColor(named: "UserIntroCollectionCellBackgroundColor")
//            cell.cellImageView.image = UIImage(named: "\(cellData.0)_default")
            cell.cellImageView.image = UIImage(named: "\(cellData.0)")
            cell.cellImageView.layer.borderWidth = 1
            cell.cellImageView.layer.borderColor = UIColor.clear.cgColor
            cell.cellImageView.layer.masksToBounds = true
            

        }
        
        cell.cellTitleLabel.text = cellData.1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // Return the size of each item in your collection view
        let width = (collectionView.frame.width - (4*5) - 10) / 5
        let height = collectionView.frame.height - 10
        return CGSize(width: width, height: height)
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

extension UserIntroSelectionTableCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let cellSelectedItem = collectionData[indexPath.row]
        switch cellType {
        case .UserMoodHoursCell:
            self.instance.moodAnswer = self.instance.moodData?.options[selectedIndex].optionTypeID
        case .UserEntryTimeSpendCell:
            self.instance.timeSpendAnswer = cellSelectedItem.1
        default:
            break
        }
        collectionView.reloadData()
    }
}
