//
//  Excercises.swift
//  sample
//
//  Created by Krishna on 8/5/24.
//

import Foundation
import UIKit


class Excercises: UIViewController {
    
    
    @IBOutlet weak var excercisesCollection: UICollectionView!
    
    
    
    @IBOutlet var topView: UIView!
    
    
    let exercises = [
            ("Mindfulness - What is it?", "mindfulness"),
            ("Progressive Muscle Relaxation", "progressive"),
            ("Touch and the Butterfly Hug", "touchAndButterfly"),
            ("Hand Over Your Heart", "handover"),
            ("Mindful Walking", "mindful"),
            ("Movement: Dance", "movement"),
            ("Movement: Running", "movementRunning"),
            ("Mindful Body Movement", "mindFulBodyMovement"),
            ("Breathing technique", "breathingTechnique")
        ]
    
    override func viewDidLoad() {
        
        

        if let layout = excercisesCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            let spacing: CGFloat = 10
            let itemWidth = (view.frame.size.width - 30) / 2
                                layout.itemSize = CGSize(width: itemWidth, height: 125)
            layout.minimumInteritemSpacing = spacing
                                layout.minimumLineSpacing = spacing
                            }
        
        self.title = "Exercises"
        
        self.excercisesCollection.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)


        
        self.excercisesCollection.clipsToBounds = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension Excercises: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
            headerView.configure(with: "Excercises")
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if(indexPath.item == 0){
            let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "MindfulNess") as! MindfulNess
                    
                    // Push to the destination view controller
                    self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        else if(indexPath.item == 1){
            
            let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "Progressive") as! Progressive
                    
                    // Push to the destination view controller
                    self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        else if(indexPath.item == 2){
            //HandOverYourHeart
            let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "TouchAndButterFly2") as! TouchAndButterFly2
                    
                    // Push to the destination view controller
                    self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        else if(indexPath.item == 3){
            //HandOverYourHeart
            let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "HandOverYourHeart") as! HandOverYourHeart
                    
                    // Push to the destination view controller
                    self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        else if(indexPath.item == 4){
            //HandOverYourHeart
            let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "MindfulWalking") as! MindfulWalking
                    
                    // Push to the destination view controller
                    self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        else if(indexPath.item == 5){
            //HandOverYourHeart
            let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovementDance") as! MovementDance
                    
                    // Push to the destination view controller
                    self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        else if(indexPath.item == 6){
            //HandOverYourHeart
            let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovementRunning") as! MovementRunning
                    
                    // Push to the destination view controller
                    self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        else if(indexPath.item == 7){
            //HandOverYourHeart
            let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "MindfulBodyMovement") as! MindfulBodyMovement
                    
                    // Push to the destination view controller
                    self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        else if(indexPath.item == 8){
            //HandOverYourHeart
            let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: "BreathingTechnique") as! BreathingTechnique
                    
                    // Push to the destination view controller
                    self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        //
        
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
        cell.layoutSubviews()
        let exercise = exercises[indexPath.row]
        cell.label.text = exercise.0
        cell.label.font = UIFont(name: Fonts().lexendRegular, size: 14)
        cell.imageView.image = UIImage(named: exercise.1)
//        let itemWidth = (view.frame.size.width - 10) / 2
//        cell.frame = CGRect(x: 0, y: 0, width: itemWidth, height: 125)
        return cell
    }
}
