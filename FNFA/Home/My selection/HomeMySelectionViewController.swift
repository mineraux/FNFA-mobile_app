//
//  HomeMySelectionViewController.swift
//  FNFA
//
//  Created by Alexandre Massé on 16/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class HomeMySelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var seeAllLabel: UILabel!
    @IBOutlet weak var seeAllImage: UIImageView!
    
    //Tap on seeAllView
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        print("tap on seeAllView")
        
    }
    
    
    var modelController: ModelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController

        sectionTitle.text = "Ma sélection"
        seeAllLabel.text = "Voir tout"
        seeAllImage.image = UIImage(named:"chevron")
        
        
        
        
        
        
        
    }
    
//    //For paging
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        //var insets = self.collectionView.contentInset
//        //let value = (self.view.frame.size.width - (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
//        //insets.left = value
//        //insets.right = value
//        //self.collectionView.contentInset = insets
//        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (modelController?.events.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mySelectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mySelectionCell", for: indexPath) as! HomeMySelectionCollectionViewCell
        
        let eventDict = modelController?.events[indexPath.row]
        
        //Category
        mySelectionCell.eventCategory.text = (eventDict?["category"] as! String)
        
        //Name
        mySelectionCell.eventName.text = (eventDict?["name"] as! String)
        
        
        //Heure
        let dateIso = eventDict!["startingDate"]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        
        if let date = formatter.date(from: dateIso as! String) {
            mySelectionCell.eventDate!.text = date.hourDate
        }
        
        //Places
        mySelectionCell.eventPlace!.text = (eventDict?["place"] as! [String]).joined(separator: ", ")
        
        //Image
        mySelectionCell.eventImage.image = UIImage(named:"seance_scolaire")
        
        mySelectionCell.layer.cornerRadius = 10;
        
        return  mySelectionCell
    }

}
