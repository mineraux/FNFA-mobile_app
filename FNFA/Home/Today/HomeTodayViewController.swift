//
//  HomeTodayViewController.swift
//  FNFA
//
//  Created by Alexandre Massé on 16/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit
import UserNotifications

class HomeTodayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var modelController: ModelController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var sectionTitleSmall: UILabel!
    @IBOutlet weak var seeAllLabel: UILabel!
    @IBOutlet weak var seeAllImage: UIImageView!
    @IBOutlet weak var seeAllView: UIView!
    
    var filteredEvents = [NSMutableDictionary]()
    let dateFilter = "mercredi 4"

    @IBAction func seeAllAction(_ sender: Any) {
        // performSegue(withIdentifier: "allEvents", sender: seeAllView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            } else {
                print("Authorization successfull")
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        
        filteredEvents = (modelController?.events
            .findBy(date: (modelController?.timestamp4Avril)!)?
            .sorted(by: .date))!
        
        let sectionTitleSmallText = "Mercredi"
        
        sectionTitleSmall.text = sectionTitleSmallText.uppercased()
        sectionTitle.text = "4 avril"
        seeAllLabel.text = "Voir tout"
        seeAllImage.image = UIImage(named:"chevron")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
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
        let todayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath) as! HomeTodayCollectionViewCell
        
        let eventDict = filteredEvents[indexPath.row]
        
        //id
        todayCell.eventId = (eventDict["id"] as! Int)
        
        //Category
        todayCell.eventCategory.text = (eventDict["category"] as! String).uppercased()
        
        //Name
        todayCell.eventName.text = (eventDict["name"] as! String)
        
        //Heure
        let dateIso = eventDict["startingDate"]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        
        if let date = formatter.date(from: dateIso as! String) {
            todayCell.eventDate!.text = date.hourDate
        }
        
        //icone
        todayCell.locationImage.image = UIImage(named:"location")
        
        //Places
        todayCell.eventPlace!.text = (eventDict["place"] as! [String]).joined(separator: ", ")
        
        //Image
        let eventID = eventDict["id"] as! Int
        let imageName = String(describing:eventID)
        
        todayCell.eventImage!.image = UIImage(named:imageName)
        
        todayCell.layer.cornerRadius = 8;
        
        favIconeManager(indexPath: indexPath, addToFavBtn: todayCell.favButton)
        
        return  todayCell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is UITapGestureRecognizer?{
            var tagSender = ((sender as! UITapGestureRecognizer).view?.tag)!
            
            if tagSender != 0 {
                tagSender -= 100
                let vc = segue.destination as! allEventsController
                vc.dayIndex = tagSender
            }
        }
        
        if let cell = sender as? HomeTodayCollectionViewCell,
            let indexPath = self.collectionView.indexPath(for: cell) {
            let vc = segue.destination as! SingleEventTableViewController
            vc.event = [filteredEvents[indexPath.row]]
        }
    }
}
