//
//  HomeTodayCollectionViewCell.swift
//  FNFA
//
//  Created by Alexandre Massé on 16/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import UIKit

class HomeTodayCollectionViewCell: UICollectionViewCell {
    
    var modelController: ModelController?
    var eventId: Int?
    var filteredEvents = [NSMutableDictionary]()
    
    @IBOutlet weak var eventCategory: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        modelController = appDelegate.modelController
        
        filteredEvents = (modelController?.getEventsByDate(events: (modelController?.events)!, date: "mercredi 4"))!
        
    }
    
    @IBAction func favAction(_ sender: Any) {
        
        modelController?.addToFavs(filteredEvents: filteredEvents, eventId: eventId!, BtnAddToFav: favButton)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.favButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.favButton.transform = CGAffineTransform.identity
                }
        })
    }
    
    
}
