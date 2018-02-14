//
//  HomeController.swift
//  FNFA
//
//  Created by MASSE Alexandre on 13/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class HomeViewContoller: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
     var modelController: ModelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (modelController?.events.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell

        let eventDict = modelController?.events[indexPath.row]
        //let categorId = (eventDict?["categoryId"] as! Int)
        //print(categorId)
        homeCell.eventCategory.text = (eventDict?["category"] as! String)
        homeCell.eventName.text = (eventDict?["name"] as! String)
        homeCell.eventTime.text = "Heure"
        homeCell.eventPlace.text = "Place"
        homeCell.layer.cornerRadius = 10;
        return homeCell
    }

}
