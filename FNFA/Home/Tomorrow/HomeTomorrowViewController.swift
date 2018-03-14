//
//  HomeTomorrowViewController.swift
//  FNFA
//
//  Created by Alexandre Massé on 16/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class HomeTomorrowViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource {
    var modelController: ModelController?
    
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var sectionTitleSmall: UILabel!
    @IBOutlet weak var seeAllLabel: UILabel!
    @IBOutlet weak var seeAllImage: UIImageView!
    
    var filteredEvents = [NSMutableDictionary]()
    let dateFilter = "jeudi 5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
         filteredEvents = (modelController?.getEventsByDate(events: (modelController?.events)!, date: dateFilter))!
        
        let sectionTitleSmallText = "JEUDI"
        
        sectionTitleSmall.text = sectionTitleSmallText.uppercased()
        sectionTitle.text = "5 avril"
        seeAllLabel.text = "Voir tout"
        seeAllImage.image = UIImage(named:"chevron")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tomorrowCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tomorrowCell", for: indexPath) as! HomeTomorrowCollectionViewCell
        
        let eventDict = filteredEvents[indexPath.row]
        
        //id
        tomorrowCell.eventId = (eventDict["id"] as! Int)
        
        //Category
        tomorrowCell.eventCategory.text = (eventDict["category"] as! String)
        
        //Name
        tomorrowCell.eventName.text = (eventDict["name"] as! String)
        
        
        //Heure
        let dateIso = eventDict["startingDate"]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        
        if let date = formatter.date(from: dateIso as! String) {
            tomorrowCell.eventDate!.text = date.hourDate
        }
        
        //Places
        tomorrowCell.eventPlace!.text = (eventDict["place"] as! [String]).joined(separator: ", ")
        
        //icone
        tomorrowCell.locationImage.image = UIImage(named:"location")
        
        //Image
        tomorrowCell.eventImage.image = UIImage(named:"seance_scolaire")
        
        tomorrowCell.layer.cornerRadius = 10;
        
        favIconeManager(indexPath: indexPath, addToFavBtn: tomorrowCell.favButton)
        
        
        return  tomorrowCell
    }
    
    // Gere quelle icone de favoris afficher pour chaque cell.
    // On utilise IndexPath pour être sur de cibler la bonne cellule
    // et ne pas avoir de problème lors du recyclage des cellules
    func favIconeManager(indexPath: IndexPath, addToFavBtn: UIButton) {
        let eventDict = filteredEvents[indexPath.row]
        if eventDict["isFav"] as! Bool == true {
            let image = UIImage(named: "heart_full")
            addToFavBtn.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "heart_empty")
            addToFavBtn.setImage(image, for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        }
    }

}
