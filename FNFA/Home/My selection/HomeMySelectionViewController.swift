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
    
    
    @objc func reloadData(_ notification: Notification) {
        self.collectionView.reloadData()
    }
    
    
    var modelController: ModelController?
    var filteredEvents = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController

        sectionTitle.text = "Ma sélection"
        seeAllLabel.text = "Voir tout"
        seeAllImage.image = UIImage(named:"chevron")
        
        
        // Observer
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .reloadData, object: nil)
        
        filteredEvents = (modelController?.events)!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
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
        return (modelController?.getEventsInFav().count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mySelectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mySelectionCell", for: indexPath) as! HomeMySelectionCollectionViewCell
        
        let eventDict = modelController?.getEventsInFav()[indexPath.row]

        //id
        mySelectionCell.eventId = (eventDict!["id"] as! Int)
        
        //Category
        mySelectionCell.eventCategory.text = (eventDict?["category"] as! String).uppercased()

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
        
        //Icone
        mySelectionCell.locationImage.image = UIImage(named:"location")

        //Places
        mySelectionCell.eventPlace!.text = (eventDict?["place"] as! [String]).joined(separator: ", ")

        //Image
        let eventID = eventDict?["id"] as! Int
        let imageName = String(describing:eventID)
        
        mySelectionCell.eventImage!.image = UIImage(named:imageName)

        mySelectionCell.layer.cornerRadius = 8;
        
        favIconeManager(indexPath: indexPath, addToFavBtn: mySelectionCell.favButton)
        
        return  mySelectionCell
    }
    
    // Gere quelle icone de favoris afficher pour chaque cell.
    // On utilise IndexPath pour être sur de cibler la bonne cellule
    // et ne pas avoir de problème lors du recyclage des cellules
    func favIconeManager(indexPath: IndexPath, addToFavBtn: UIButton) {
        let eventDict = modelController?.getEventsInFav()[indexPath.row]
        if eventDict!["isFav"] as! Bool == true {
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
        if let cell = sender as? HomeMySelectionCollectionViewCell,
            let indexPath = self.collectionView.indexPath(for: cell) {
            let vc = segue.destination as! SingleEventTableViewController
            vc.event = [(modelController?.getEventsInFav()[indexPath.row])!]
        }
    }
}
